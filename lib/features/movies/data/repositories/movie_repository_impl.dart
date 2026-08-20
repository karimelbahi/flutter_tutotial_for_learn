import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_model.dart';

/// Concrete repository — coordinates **remote fetch** + **local SSOT cache**.
///
/// ## Cache-First rules (Principle VI)
///
/// | Method prefix | Purpose |
/// |---------------|---------|
/// | `watch*` | Read from Hive → map to domain entities → Stream for Cubits |
/// | `refresh*` | TMDB → save Hive (stream auto-updates watchers) |
/// | `get*` | Legacy one-shot remote fetch (other cubits until migrated) |
///
/// Cubits being migrated call `watch*` + `refresh*` instead of `get*`.
class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({
    MovieRemoteDataSource? remoteDataSource,
    MovieLocalDataSource? localDataSource,
  })  : _remoteDataSource =
            remoteDataSource ?? MovieRemoteDataSourceImpl(),
        _localDataSource =
            localDataSource ?? MovieLocalDataSourceImpl();

  final MovieRemoteDataSource _remoteDataSource;
  final MovieLocalDataSource _localDataSource;

  // ── Cache-First: Popular movies ───────────────────────────────────────────

  @override
  Stream<List<Movie>> watchPopularMovies() {
    return _localDataSource.watchPopularMovies().map(_mapMovieModels);
  }

  @override
  Future<Result<void>> refreshPopularMovies() {
    return _refreshMovieList(_remoteDataSource.fetchPopularMovies, (models) {
      return _localDataSource.savePopularMovies(models);
    });
  }

  // ── Cache-First: Top rated ────────────────────────────────────────────────

  @override
  Stream<List<Movie>> watchTopRatedMovies() {
    return _localDataSource.watchTopRatedMovies().map(_mapMovieModels);
  }

  @override
  Future<Result<void>> refreshTopRatedMovies() {
    return _refreshMovieList(_remoteDataSource.fetchTopRatedMovies, (models) {
      return _localDataSource.saveTopRatedMovies(models);
    });
  }

  // ── Cache-First: Upcoming ─────────────────────────────────────────────────

  @override
  Stream<List<Movie>> watchUpcomingMovies() {
    return _localDataSource.watchUpcomingMovies().map(_mapMovieModels);
  }

  @override
  Future<Result<void>> refreshUpcomingMovies() {
    return _refreshMovieList(_remoteDataSource.fetchUpcomingMovies, (models) {
      return _localDataSource.saveUpcomingMovies(models);
    });
  }

  // ── Cache-First: Genre tabs (one cache key per genre id) ──────────────────

  @override
  Stream<List<Movie>> watchMoviesByGenre(int genreId) {
    return _localDataSource
        .watchMoviesByGenre(genreId)
        .map(_mapMovieModels);
  }

  @override
  Future<Result<void>> refreshMoviesByGenre(int genreId) {
    return _refreshMovieList(
      () => _remoteDataSource.fetchMoviesByGenre(genreId),
      (models) => _localDataSource.saveMoviesByGenre(genreId, models),
    );
  }

  // ── Cache-First: Movie detail screen sections ─────────────────────────────

  @override
  Stream<MovieDetail?> watchMovieDetail(int movieId) {
    return _localDataSource
        .watchMovieDetail(movieId)
        .map((model) => model?.toEntity());
  }

  @override
  Future<Result<void>> refreshMovieDetail(int movieId) {
    return _refreshVoid(() async {
      final model = await _remoteDataSource.fetchMovieDetail(movieId);
      await _localDataSource.saveMovieDetail(movieId, model);
    });
  }

  @override
  Stream<List<CastMember>> watchMovieCast(int movieId) {
    return _localDataSource.watchMovieCast(movieId).map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }

  @override
  Future<Result<void>> refreshMovieCast(int movieId) {
    return _refreshVoid(() async {
      final models = await _remoteDataSource.fetchMovieCast(movieId);
      await _localDataSource.saveMovieCast(movieId, models);
    });
  }

  @override
  Stream<List<Movie>> watchSimilarMovies(int movieId) {
    return _localDataSource
        .watchSimilarMovies(movieId)
        .map(_mapMovieModels);
  }

  @override
  Future<Result<void>> refreshSimilarMovies(int movieId) {
    return _refreshMovieList(
      () => _remoteDataSource.fetchSimilarMovies(movieId),
      (models) => _localDataSource.saveSimilarMovies(movieId, models),
    );
  }

  // ── Legacy one-shot APIs (remote-only until cubit migration) ─────────────

  @override
  Future<Result<List<Movie>>> getPopularMovies() {
    return _fetchMovies(_remoteDataSource.fetchPopularMovies);
  }

  @override
  Future<Result<List<Movie>>> getMoviesByGenre(int genreId) {
    return _fetchMovies(() => _remoteDataSource.fetchMoviesByGenre(genreId));
  }

  @override
  Future<Result<List<Movie>>> getTopRatedMovies() {
    return _fetchMovies(_remoteDataSource.fetchTopRatedMovies);
  }

  @override
  Future<Result<List<Movie>>> getUpcomingMovies() {
    return _fetchMovies(_remoteDataSource.fetchUpcomingMovies);
  }

  @override
  Future<Result<List<Movie>>> searchMovies(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return Future.value(const Success([]));
    }
    return _fetchMovies(() => _remoteDataSource.fetchSearchMovies(trimmed));
  }

  @override
  Future<Result<MovieDetail>> getMovieDetail(int movieId) async {
    try {
      final model = await _remoteDataSource.fetchMovieDetail(movieId);
      return Success(model.toEntity());
    } on DioException catch (error) {
      return Error(_mapDioException(error));
    } on NetworkException catch (error) {
      return Error(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Error(ServerFailure(error.message));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<List<CastMember>>> getMovieCast(int movieId) async {
    try {
      final models = await _remoteDataSource.fetchMovieCast(movieId);
      final cast = models.map((model) => model.toEntity()).toList();
      return Success(cast);
    } on DioException catch (error) {
      return Error(_mapDioException(error));
    } on NetworkException catch (error) {
      return Error(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Error(ServerFailure(error.message));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<List<Movie>>> getSimilarMovies(int movieId) {
    return _fetchMovies(() => _remoteDataSource.fetchSimilarMovies(movieId));
  }

  // ── Shared helpers ───────────────────────────────────────────────────────

  List<Movie> _mapMovieModels(List<MovieModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  /// Network → Hive refresh for non-list payloads (detail, cast, …).
  Future<Result<void>> _refreshVoid(Future<void> Function() save) async {
    try {
      await save();
      return const Success(null);
    } on DioException catch (error) {
      return Error(_mapDioException(error));
    } on NetworkException catch (error) {
      return Error(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Error(ServerFailure(error.message));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error occurred'));
    }
  }

  /// Network → Hive refresh used by every list `refresh*` method.
  Future<Result<void>> _refreshMovieList(
    Future<List<MovieModel>> Function() fetch,
    Future<void> Function(List<MovieModel> models) save,
  ) async {
    try {
      final models = await fetch();
      await save(models);
      return const Success(null);
    } on DioException catch (error) {
      return Error(_mapDioException(error));
    } on NetworkException catch (error) {
      return Error(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Error(ServerFailure(error.message));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error occurred'));
    }
  }

  Failure _mapDioException(DioException error) {
    final cause = error.error;
    if (cause is NetworkException) {
      return NetworkFailure(cause.message);
    }
    if (cause is ServerException) {
      return ServerFailure(cause.message);
    }
    return NetworkFailure(error.message ?? 'Network error occurred');
  }

  /// Shared error-handling wrapper for legacy `get*` list methods.
  Future<Result<List<Movie>>> _fetchMovies(
    Future<List<MovieModel>> Function() fetch,
  ) async {
    try {
      final models = await fetch();
      final movies = _mapMovieModels(models);
      return Success(movies);
    } on DioException catch (error) {
      return Error(_mapDioException(error));
    } on NetworkException catch (error) {
      return Error(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Error(ServerFailure(error.message));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error occurred'));
    }
  }
}
