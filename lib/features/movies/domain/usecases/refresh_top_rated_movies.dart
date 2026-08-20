import '../../../../core/utils/result.dart';
import '../repositories/movie_repository.dart';

/// Background TMDB fetch → Hive for the top-rated row.
class RefreshTopRatedMovies {
  const RefreshTopRatedMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<void>> call() => _repository.refreshTopRatedMovies();
}
