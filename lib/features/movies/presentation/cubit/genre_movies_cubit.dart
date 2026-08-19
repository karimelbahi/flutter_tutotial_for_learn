import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_genre_movies.dart';
import 'genre_movies_state.dart';

/// Loads movies for the selected TMDB genre tab.
///
/// Tracks [_latestGenreId] so rapid tab switches do not show stale results
/// from an older in-flight request (checkpoint SC-006).
class GenreMoviesCubit extends Cubit<GenreMoviesState> {
  GenreMoviesCubit(this._getGenreMovies, {required int initialGenreId})
      : _latestGenreId = initialGenreId,
        super(GenreMoviesInitial(genreId: initialGenreId));

  final GetGenreMovies _getGenreMovies;

  int _latestGenreId;

  Future<void> load(int genreId) async {
    _latestGenreId = genreId;
    emit(GenreMoviesLoading(genreId: genreId));

    final result = await _getGenreMovies(genreId);

    if (isClosed || genreId != _latestGenreId) {
      return;
    }

    if (result.isSuccess) {
      emit(GenreMoviesSuccess(
        genreId: genreId,
        movies: result.dataOrNull!,
      ));
      return;
    }

    emit(GenreMoviesFailure(
      genreId: genreId,
      message: result.failureOrNull?.message ?? 'Unexpected error occurred',
    ));
  }
}
