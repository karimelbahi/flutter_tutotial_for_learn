import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Use case — search movies by title query.
///
/// The search Cubit calls this use case, NOT the repository directly.
/// Empty/whitespace queries are handled in the Cubit (no API call);
/// the repository also returns an empty list if called with blank text.
class SearchMovies {
  const SearchMovies(this._repository);

  final MovieRepository _repository;

  Future<Result<List<Movie>>> call(String query) {
    return _repository.searchMovies(query);
  }
}
