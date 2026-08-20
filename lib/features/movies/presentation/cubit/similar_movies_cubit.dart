import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_similar_movies.dart';
import 'similar_movies_state.dart';

/// Loads similar movies for the horizontal row on the detail screen.
class SimilarMoviesCubit extends Cubit<SimilarMoviesState> {
  SimilarMoviesCubit(this._getSimilarMovies)
      : super(const SimilarMoviesInitial());

  final GetSimilarMovies _getSimilarMovies;

  int _latestMovieId = 0;

  Future<void> load(int movieId) async {
    _latestMovieId = movieId;
    emit(const SimilarMoviesLoading());

    final result = await _getSimilarMovies(movieId);

    if (isClosed || movieId != _latestMovieId) {
      return;
    }

    if (result.isSuccess) {
      emit(SimilarMoviesSuccess(result.dataOrNull!));
      return;
    }

    emit(SimilarMoviesFailure(
      message: result.failureOrNull?.message ?? 'Unexpected error occurred',
      movieId: movieId,
    ));
  }
}
