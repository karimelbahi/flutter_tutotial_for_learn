import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/exceptions.dart';
import 'package:flutter_tutotial_for_learn/core/storage/hive_service.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_credits_model.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_detail_model.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_model.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/repositories/movie_repository_impl.dart';

/// Fake TMDB remote layer for repository integration tests.
///
/// We inject this instead of hitting the real API — tests stay fast and offline-safe.
class _FakeRemoteDataSource implements MovieRemoteDataSource {
  _FakeRemoteDataSource({
    this.popularMovies = const [],
    this.failPopular = false,
  });

  List<MovieModel> popularMovies;
  bool failPopular;

  @override
  Future<List<MovieModel>> fetchPopularMovies() async {
    if (failPopular) {
      throw const NetworkException('offline');
    }
    return popularMovies;
  }

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
  Future<MovieDetailModel> fetchMovieDetail(int movieId) =>
      throw UnimplementedError();

  @override
  Future<List<CastMemberModel>> fetchMovieCast(int movieId) =>
      throw UnimplementedError();

  @override
  Future<List<MovieModel>> fetchSimilarMovies(int movieId) =>
      throw UnimplementedError();
}

void main() {
  late MovieRepositoryImpl repository;
  late _FakeRemoteDataSource remote;

  setUp(() async {
    await HiveService.instance.initForTest();
    remote = _FakeRemoteDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: MovieLocalDataSourceImpl(),
    );
  });

  tearDown(() async {
    await HiveService.instance.closeForTest();
  });

  group('MovieRepositoryImpl — cache-first popular movies', () {
    test('watch emits empty list on cold cache', () async {
      final first = await repository.watchPopularMovies().first;
      expect(first, isEmpty);
    });

    test('refresh writes Hive and watch re-emits movies', () async {
      remote.popularMovies = const [
        MovieModel(id: 1, title: 'Cached Movie', voteAverage: 8),
      ];

      final values = repository.watchPopularMovies().take(2).toList();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final refreshResult = await repository.refreshPopularMovies();
      expect(refreshResult.isSuccess, isTrue);

      final emitted = await values;
      expect(emitted.first, isEmpty);
      expect(emitted.last.single.title, 'Cached Movie');
    });

    test('refresh failure keeps cached data available on watch stream', () async {
      remote.popularMovies = const [
        MovieModel(id: 2, title: 'Offline Movie', voteAverage: 7),
      ];

      await repository.refreshPopularMovies();
      expect(await repository.watchPopularMovies().first, isNotEmpty);

      remote.failPopular = true;
      final refreshResult = await repository.refreshPopularMovies();
      expect(refreshResult.isFailure, isTrue);

      // SSOT: Hive still serves cached entities after network failure.
      final cached = await repository.watchPopularMovies().first;
      expect(cached.single.title, 'Offline Movie');
    });
  });
}
