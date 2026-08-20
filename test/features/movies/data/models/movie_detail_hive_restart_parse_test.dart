import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/storage/hive_service.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_detail_model.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_credits_model.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_model.dart';

class _FakeRemote implements MovieRemoteDataSource {
  @override
  Future<MovieDetailModel> fetchMovieDetail(int movieId) async {
    return MovieDetailModel.fromJson({
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
  test('diagnose hive persisted detail parse failure', () async {
    final hivePath = Directory.systemTemp.createTempSync('hive_diag').path;
    await HiveService.instance.initForTest(directoryPath: hivePath);

    final repository = MovieRepositoryImpl(
      remoteDataSource: _FakeRemote(),
      localDataSource: MovieLocalDataSourceImpl(),
    );
    await repository.refreshMovieDetail(550);

    await HiveService.instance.closeForTest();
    await HiveService.instance.initForTest(directoryPath: hivePath);

    final raw = HiveService.instance.movieDetailsBox.get('550');
    expect(raw, isNotNull);

    final genres = (raw as Map)['genres'] as List;
    expect(genres, isNotEmpty);
    expect(genres.first.runtimeType.toString(), isNotEmpty);

    Object? parseError;
    try {
      MovieDetailModel.fromJson(Map<String, dynamic>.from(raw as Map));
    } catch (e) {
      parseError = e;
    }

    expect(parseError, isNull, reason: 'fromJson failed: $parseError');

    await HiveService.instance.closeForTest();
  });
}
