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

  Future<Result<List<Movie>>> getPopularMovies();

  Future<Result<List<Movie>>> getMoviesByGenre(int genreId);

  Future<Result<List<Movie>>> getTopRatedMovies();

  Future<Result<List<Movie>>> getUpcomingMovies();

  Future<Result<List<Movie>>> searchMovies(String query);

  Future<Result<MovieDetail>> getMovieDetail(int movieId);

  Future<Result<List<CastMember>>> getMovieCast(int movieId);

  Future<Result<List<Movie>>> getSimilarMovies(int movieId);
}
