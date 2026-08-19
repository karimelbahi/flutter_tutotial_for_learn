import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Fetches the top-rated movies row on the home screen.
class GetTopRatedMovies {
  const GetTopRatedMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<List<Movie>>> call() {
    return _repository.getTopRatedMovies();
  }
}
