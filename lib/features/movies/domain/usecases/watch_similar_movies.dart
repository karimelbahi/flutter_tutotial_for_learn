import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Subscribe to cached similar movies for one [movieId] (SSOT).
class WatchSimilarMovies {
  const WatchSimilarMovies(this._repository);

  final MovieRepository _repository;

  Stream<List<Movie>> call(int movieId) =>
      _repository.watchSimilarMovies(movieId);
}
