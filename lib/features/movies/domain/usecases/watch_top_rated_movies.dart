import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Subscribe to the top-rated row from local Hive cache (SSOT).
class WatchTopRatedMovies {
  const WatchTopRatedMovies(this._repository);

  final MovieRepository _repository;

  Stream<List<Movie>> call() => _repository.watchTopRatedMovies();
}
