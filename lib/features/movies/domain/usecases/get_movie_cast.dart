import '../../../../core/utils/result.dart';
import '../entities/cast_member.dart';
import '../repositories/movie_repository.dart';

/// Loads cast list for the movie detail screen.
class GetMovieCast {
  const GetMovieCast(this._repository);

  final MovieRepository _repository;

  Future<Result<List<CastMember>>> call(int movieId) {
    return _repository.getMovieCast(movieId);
  }
}
