import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_movie_detail.dart';
import '../utils/error_messages.dart';
import 'movie_detail_state.dart';

/// Loads full movie detail for the detail screen.
///
/// Tracks [_latestMovieId] so a slow response does not overwrite a newer
/// detail request when the user taps a similar movie (T030).
class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit(this._getMovieDetail) : super(const MovieDetailInitial());

  final GetMovieDetail _getMovieDetail;

  int _latestMovieId = 0;

  Future<void> load(int movieId) async {
    _latestMovieId = movieId;
    emit(const MovieDetailLoading());

    final result = await _getMovieDetail(movieId);

    if (isClosed || movieId != _latestMovieId) {
      return;
    }

    if (result.isSuccess) {
      emit(MovieDetailSuccess(result.dataOrNull!));
      return;
    }

    emit(MovieDetailFailure(
      message: localizedFailureMessage(result.failureOrNull?.message),
      movieId: movieId,
    ));
  }
}
