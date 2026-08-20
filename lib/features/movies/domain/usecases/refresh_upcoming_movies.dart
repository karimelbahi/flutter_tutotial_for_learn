import '../../../../core/utils/result.dart';
import '../repositories/movie_repository.dart';

/// Background TMDB fetch → Hive for the upcoming row.
class RefreshUpcomingMovies {
  const RefreshUpcomingMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<void>> call() => _repository.refreshUpcomingMovies();
}
