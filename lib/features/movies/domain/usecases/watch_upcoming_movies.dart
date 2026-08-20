import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Subscribe to the upcoming row from local Hive cache (SSOT).
class WatchUpcomingMovies {
  const WatchUpcomingMovies(this._repository);

  final MovieRepository _repository;

  Stream<List<Movie>> call() => _repository.watchUpcomingMovies();
}
