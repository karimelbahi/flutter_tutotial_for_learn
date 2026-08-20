import '../entities/cast_member.dart';
import '../repositories/movie_repository.dart';

/// Subscribe to cached cast list for one [movieId] (SSOT).
class WatchMovieCast {
  const WatchMovieCast(this._repository);

  final MovieRepository _repository;

  Stream<List<CastMember>> call(int movieId) =>
      _repository.watchMovieCast(movieId);
}
