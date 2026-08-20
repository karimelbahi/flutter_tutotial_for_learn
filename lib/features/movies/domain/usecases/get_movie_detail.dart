import '../../../../core/utils/result.dart';
import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

/// Loads full movie detail for the detail screen (spec 003-movie-detail).
class GetMovieDetail {
  const GetMovieDetail(this._repository);

  final MovieRepository _repository;

  Future<Result<MovieDetail>> call(int movieId) {
    return _repository.getMovieDetail(movieId);
  }
}
