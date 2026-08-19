import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Use case — one business action per class (Single Responsibility).
///
/// The Cubit calls the use case, NOT the repository directly.
/// This keeps Cubits thin and makes each action easy to test.
///
/// Usage in Cubit (Step 4+):
///   final result = await _getPopularMovies();
///   if (result.isSuccess) emit(Success(result.dataOrNull!));
class GetPopularMovies {
  const GetPopularMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<List<Movie>>> call() {
    return _repository.getPopularMovies();
  }
}
