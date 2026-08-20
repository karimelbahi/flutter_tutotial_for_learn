import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Subscribe to a genre tab's movies from local Hive cache (SSOT).
///
/// Each [genreId] has its own cache key, e.g. `genre_28` for Action.
class WatchGenreMovies {
  const WatchGenreMovies(this._repository);

  final MovieRepository _repository;

  Stream<List<Movie>> call(int genreId) =>
      _repository.watchMoviesByGenre(genreId);
}
