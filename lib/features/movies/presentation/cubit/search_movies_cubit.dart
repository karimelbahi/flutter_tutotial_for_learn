import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_movies.dart';
import 'search_movies_state.dart';

/// Loads TMDB search results for a debounced text query.
///
/// Tracks [_latestQuery] so rapid typing or clear does not show stale results
/// from an older in-flight request (SC-002).
class SearchMoviesCubit extends Cubit<SearchMoviesState> {
  SearchMoviesCubit(this._searchMovies) : super(const SearchMoviesInitial());

  final SearchMovies _searchMovies;

  String _latestQuery = '';

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      reset();
      return;
    }

    _latestQuery = trimmed;
    emit(SearchMoviesLoading(query: trimmed));

    final result = await _searchMovies(trimmed);

    if (isClosed || trimmed != _latestQuery) {
      return;
    }

    if (result.isSuccess) {
      final movies = result.dataOrNull!;
      if (movies.isEmpty) {
        emit(SearchMoviesEmpty(query: trimmed));
      } else {
        emit(SearchMoviesSuccess(movies: movies, query: trimmed));
      }
      return;
    }

    emit(SearchMoviesFailure(
      message: result.failureOrNull?.message ?? 'Unexpected error occurred',
      query: trimmed,
    ));
  }

  void reset() {
    _latestQuery = '';
    emit(const SearchMoviesInitial());
  }
}
