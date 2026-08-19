import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Fetches movies filtered by TMDB genre ID (home screen genre tabs).
class GetGenreMovies {
  const GetGenreMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<List<Movie>>> call(int genreId) {
    return _repository.getMoviesByGenre(genreId);
  }
}
