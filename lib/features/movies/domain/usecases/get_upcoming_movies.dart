import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Fetches upcoming releases for the home screen bottom row.
class GetUpcomingMovies {
  const GetUpcomingMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<List<Movie>>> call() {
    return _repository.getUpcomingMovies();
  }
}
