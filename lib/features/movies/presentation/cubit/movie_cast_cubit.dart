import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_movie_cast.dart';
import '../utils/error_messages.dart';
import 'movie_cast_state.dart';

/// Loads cast members independently from movie detail (FR-008).
class MovieCastCubit extends Cubit<MovieCastState> {
  MovieCastCubit(this._getMovieCast) : super(const MovieCastInitial());

  final GetMovieCast _getMovieCast;

  int _latestMovieId = 0;

  Future<void> load(int movieId) async {
    _latestMovieId = movieId;
    emit(const MovieCastLoading());

    final result = await _getMovieCast(movieId);

    if (isClosed || movieId != _latestMovieId) {
      return;
    }

    if (result.isSuccess) {
      emit(MovieCastSuccess(result.dataOrNull!));
      return;
    }

    emit(MovieCastFailure(
      message: localizedFailureMessage(result.failureOrNull?.message),
      movieId: movieId,
    ));
  }
}
