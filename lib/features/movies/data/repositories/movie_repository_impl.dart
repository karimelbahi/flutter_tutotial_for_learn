import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_model.dart';

/// Concrete repository — bridges domain contract ↔ remote data source.
///
/// Responsibilities:
/// 1. Call [MovieRemoteDataSource] for raw data
/// 2. Map [MovieModel] → [Movie] via `toEntity()`
/// 3. Catch exceptions → return [Result.failure] (never throw to Cubit)
class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({MovieRemoteDataSource? remoteDataSource})
      : _remoteDataSource =
            remoteDataSource ?? MovieRemoteDataSourceImpl();

  final MovieRemoteDataSource _remoteDataSource;

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

  /// Shared error-handling wrapper for all fetch methods.
  Future<Result<List<Movie>>> _fetchMovies(
    Future<List<MovieModel>> Function() fetch,
  ) async {
    try {
      final models = await fetch();
      // Convert every data model to a domain entity before returning
      final movies = models.map((model) => model.toEntity()).toList();
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
