import '../../../../core/utils/result.dart';
import '../entities/cast_member.dart';
import '../entities/movie.dart';
import '../entities/movie_detail.dart';

/// Abstract contract — domain layer defines WHAT, not HOW.
///
/// Presentation (Cubit) and use cases depend on this interface.
/// The **implementation** lives in `data/repositories/movie_repository_impl.dart`.
///
/// This is the Clean Architecture "port" — easy to mock in tests later.
abstract class MovieRepository {
  /// Reactive read from local cache (SSOT). Emits current cache immediately.
  Stream<List<Movie>> watchPopularMovies();

  /// Fetches from TMDB and writes to local cache. Does not return UI data directly.
  Future<Result<void>> refreshPopularMovies();

  Stream<List<Movie>> watchTopRatedMovies();

  Future<Result<void>> refreshTopRatedMovies();

  Stream<List<Movie>> watchUpcomingMovies();

  Future<Result<void>> refreshUpcomingMovies();

  Stream<List<Movie>> watchMoviesByGenre(int genreId);

  Future<Result<void>> refreshMoviesByGenre(int genreId);

  Stream<MovieDetail?> watchMovieDetail(int movieId);

  Future<Result<void>> refreshMovieDetail(int movieId);

  Stream<List<CastMember>> watchMovieCast(int movieId);

  Future<Result<void>> refreshMovieCast(int movieId);

  Stream<List<Movie>> watchSimilarMovies(int movieId);

  Future<Result<void>> refreshSimilarMovies(int movieId);

  /// Network-first in v1 (spec 005) — search queries are not cached in Hive.
  Future<Result<List<Movie>>> searchMovies(String query);

  @Deprecated('Use watchPopularMovies + refreshPopularMovies. Spec 005 SSOT.')
  Future<Result<List<Movie>>> getPopularMovies();

  @Deprecated('Use watchMoviesByGenre + refreshMoviesByGenre. Spec 005 SSOT.')
  Future<Result<List<Movie>>> getMoviesByGenre(int genreId);

  @Deprecated('Use watchTopRatedMovies + refreshTopRatedMovies. Spec 005 SSOT.')
  Future<Result<List<Movie>>> getTopRatedMovies();

  @Deprecated('Use watchUpcomingMovies + refreshUpcomingMovies. Spec 005 SSOT.')
  Future<Result<List<Movie>>> getUpcomingMovies();

  @Deprecated('Use watchMovieDetail + refreshMovieDetail. Spec 005 SSOT.')
  Future<Result<MovieDetail>> getMovieDetail(int movieId);

  @Deprecated('Use watchMovieCast + refreshMovieCast. Spec 005 SSOT.')
  Future<Result<List<CastMember>>> getMovieCast(int movieId);

  @Deprecated('Use watchSimilarMovies + refreshSimilarMovies. Spec 005 SSOT.')
  Future<Result<List<Movie>>> getSimilarMovies(int movieId);
}
