import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

/// Subscribe to cached movie detail for one [movieId] (SSOT).
///
/// Emits `null` when this movie was never opened before (cold cache).
class WatchMovieDetail {
  const WatchMovieDetail(this._repository);

  final MovieRepository _repository;

  Stream<MovieDetail?> call(int movieId) =>
      _repository.watchMovieDetail(movieId);
}
