import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Loads similar movies for the horizontal row on the detail screen.
class GetSimilarMovies {
  const GetSimilarMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<List<Movie>>> call(int movieId) {
    return _repository.getSimilarMovies(movieId);
  }
}
