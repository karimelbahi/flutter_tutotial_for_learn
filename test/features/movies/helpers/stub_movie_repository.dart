import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/cast_member.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie_detail.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/repositories/movie_repository.dart';

/// Base fake repository — override only what your test needs.
///
/// Keeps cubit tests short: you don't repeat `throw UnimplementedError()` for
/// every cache-first method on [MovieRepository].
class StubMovieRepository implements MovieRepository {
  @override
  Stream<List<Movie>> watchPopularMovies() => throw UnimplementedError();

  @override
  Future<Result<void>> refreshPopularMovies() => throw UnimplementedError();

  @override
  Stream<List<Movie>> watchTopRatedMovies() => throw UnimplementedError();

  @override
  Future<Result<void>> refreshTopRatedMovies() => throw UnimplementedError();

  @override
  Stream<List<Movie>> watchUpcomingMovies() => throw UnimplementedError();

  @override
  Future<Result<void>> refreshUpcomingMovies() => throw UnimplementedError();

  @override
  Stream<List<Movie>> watchMoviesByGenre(int genreId) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> refreshMoviesByGenre(int genreId) =>
      throw UnimplementedError();

  @override
  Stream<MovieDetail?> watchMovieDetail(int movieId) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> refreshMovieDetail(int movieId) =>
      throw UnimplementedError();

  @override
  Stream<List<CastMember>> watchMovieCast(int movieId) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> refreshMovieCast(int movieId) =>
      throw UnimplementedError();

  @override
  Stream<List<Movie>> watchSimilarMovies(int movieId) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> refreshSimilarMovies(int movieId) =>
      throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> getPopularMovies() => throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> getMoviesByGenre(int genreId) =>
      throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> getTopRatedMovies() => throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> getUpcomingMovies() => throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> searchMovies(String query) =>
      throw UnimplementedError();

  @override
  Future<Result<MovieDetail>> getMovieDetail(int movieId) =>
      throw UnimplementedError();

  @override
  Future<Result<List<CastMember>>> getMovieCast(int movieId) =>
      throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> getSimilarMovies(int movieId) =>
      throw UnimplementedError();
}
