import '../../../../core/utils/result.dart';
import '../repositories/movie_repository.dart';

/// Background TMDB credits fetch → Hive for one [movieId].
class RefreshMovieCast {
  const RefreshMovieCast(this._repository);

  final MovieRepository _repository;

  Future<Result<void>> call(int movieId) =>
      _repository.refreshMovieCast(movieId);
}
