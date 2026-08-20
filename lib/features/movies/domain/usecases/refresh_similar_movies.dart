import '../../../../core/utils/result.dart';
import '../repositories/movie_repository.dart';

/// Background TMDB similar-movies fetch → Hive for one [movieId].
class RefreshSimilarMovies {
  const RefreshSimilarMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<void>> call(int movieId) =>
      _repository.refreshSimilarMovies(movieId);
}
