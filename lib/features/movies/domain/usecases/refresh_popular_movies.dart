import '../../../../core/utils/result.dart';
import '../repositories/movie_repository.dart';

/// Use case — background TMDB fetch that **writes Hive only**.
///
/// UI updates happen when [WatchPopularMovies] stream fires after the save.
/// Returns [Result<void>] because the Cubit already has data from the watch stream.
class RefreshPopularMovies {
  const RefreshPopularMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<void>> call() => _repository.refreshPopularMovies();
}
