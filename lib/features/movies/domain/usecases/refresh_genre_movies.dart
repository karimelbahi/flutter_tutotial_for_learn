import '../../../../core/utils/result.dart';
import '../repositories/movie_repository.dart';

/// Background TMDB fetch → Hive for one genre tab.
class RefreshGenreMovies {
  const RefreshGenreMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<void>> call(int genreId) =>
      _repository.refreshMoviesByGenre(genreId);
}
