import '../../../../core/utils/result.dart';
import '../entities/movie.dart';

/// Abstract contract — domain layer defines WHAT, not HOW.
///
/// Presentation (Cubit) and use cases depend on this interface.
/// The **implementation** lives in `data/repositories/movie_repository_impl.dart`.
///
/// This is the Clean Architecture "port" — easy to mock in tests later.
abstract class MovieRepository {
  Future<Result<List<Movie>>> getPopularMovies();

  Future<Result<List<Movie>>> getMoviesByGenre(int genreId);

  Future<Result<List<Movie>>> getTopRatedMovies();

  Future<Result<List<Movie>>> getUpcomingMovies();
}
