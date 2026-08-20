import '../../../../core/utils/result.dart';
import '../repositories/movie_repository.dart';

/// Background TMDB detail fetch → Hive for one [movieId].
class RefreshMovieDetail {
  const RefreshMovieDetail(this._repository);

  final MovieRepository _repository;

  Future<Result<void>> call(int movieId) =>
      _repository.refreshMovieDetail(movieId);
}
