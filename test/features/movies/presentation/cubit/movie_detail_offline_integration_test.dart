import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/exceptions.dart';
import 'package:flutter_tutotial_for_learn/core/storage/hive_service.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_credits_model.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_detail_model.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_model.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/refresh_movie_detail.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/watch_movie_detail.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/movie_detail_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/movie_detail_state.dart';

class _FakeRemoteDataSource implements MovieRemoteDataSource {
  _FakeRemoteDataSource({
    this.detail,
    this.failDetail = false,
  });

  MovieDetailModel? detail;
  var failDetail = false;

  @override
  Future<MovieDetailModel> fetchMovieDetail(int movieId) async {
    if (failDetail) {
      throw const NetworkException('Failed host lookup');
    }
    return detail ??
        MovieDetailModel.fromJson({
          'id': movieId,
          'title': 'Cached Movie',
          'vote_average': 8.1,
          'revenue': 1000,
          'status': 'Released',
          'genres': [
            {'id': 28, 'name': 'Action'},
          ],
          'images': {
            'backdrops': [
              {'file_path': '/backdrop.jpg'},
            ],
          },
        });
  }

  @override
  Future<List<MovieModel>> fetchPopularMovies() => throw UnimplementedError();
  @override
  Future<List<MovieModel>> fetchMoviesByGenre(int genreId) =>
      throw UnimplementedError();
  @override
  Future<List<MovieModel>> fetchTopRatedMovies() => throw UnimplementedError();
  @override
  Future<List<MovieModel>> fetchUpcomingMovies() => throw UnimplementedError();
  @override
  Future<List<MovieModel>> fetchSearchMovies(String query) =>
      throw UnimplementedError();
  @override
  Future<List<CastMemberModel>> fetchMovieCast(int movieId) =>
      throw UnimplementedError();
  @override
  Future<List<MovieModel>> fetchSimilarMovies(int movieId) =>
      throw UnimplementedError();
}

void main() {
  late _FakeRemoteDataSource remote;
  late MovieRepositoryImpl repository;
  late String hivePath;

  setUp(() async {
    hivePath = Directory.systemTemp.createTempSync('hive_detail_int').path;
    await HiveService.instance.initForTest(directoryPath: hivePath);
    remote = _FakeRemoteDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: MovieLocalDataSourceImpl(),
    );
  });

  tearDown(() async {
    await HiveService.instance.closeForTest();
  });

  test('detail cubit shows cached data after app restart when offline', () async {
    // Online visit — persist detail to Hive.
    final onlineRefresh = await repository.refreshMovieDetail(550);
    expect(onlineRefresh.isSuccess, isTrue);
    expect(await repository.watchMovieDetail(550).first, isNotNull);

    // Simulate killing and reopening the app (Hive persists on disk in prod).
    await HiveService.instance.closeForTest();
    await HiveService.instance.initForTest(directoryPath: hivePath);

    final rawAfterRestart =
        HiveService.instance.movieDetailsBox.get('550');
    expect(rawAfterRestart, isNotNull,
        reason: 'Raw Hive entry should exist after restart');

    repository = MovieRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: MovieLocalDataSourceImpl(),
    );
    remote.failDetail = true;

    final cachedBeforeLoad = await repository.watchMovieDetail(550).first;
    expect(cachedBeforeLoad, isNotNull,
        reason: 'Hive should still serve cached detail after restart');

    final cubit = MovieDetailCubit(
      WatchMovieDetail(repository),
      RefreshMovieDetail(repository),
    );
    addTearDown(cubit.close);

    await cubit.load(550);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<MovieDetailSuccess>());
    expect(cubit.state, isNot(isA<MovieDetailFailure>()));
    expect((cubit.state as MovieDetailSuccess).detail.title, 'Cached Movie');
    expect((cubit.state as MovieDetailSuccess).isStale, isTrue);
  });
}
