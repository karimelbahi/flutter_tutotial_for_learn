import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Use case — subscribe to popular movies from **local cache** (SSOT).
///
/// The Cubit listens to this stream; it never reads network data directly.
/// When the repository saves fresh TMDB data to Hive, this stream re-emits.
class WatchPopularMovies {
  const WatchPopularMovies(this._repository);

  final MovieRepository _repository;

  Stream<List<Movie>> call() => _repository.watchPopularMovies();
}
