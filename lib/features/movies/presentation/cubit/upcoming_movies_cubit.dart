import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_upcoming_movies.dart';
import 'upcoming_movies_state.dart';

/// Loads TMDB upcoming movies for the home horizontal row.
class UpcomingMoviesCubit extends Cubit<UpcomingMoviesState> {
  UpcomingMoviesCubit(this._getUpcomingMovies)
      : super(const UpcomingMoviesInitial());

  final GetUpcomingMovies _getUpcomingMovies;

  Future<void> load() async {
    emit(const UpcomingMoviesLoading());

    final result = await _getUpcomingMovies();

    if (result.isSuccess) {
      emit(UpcomingMoviesSuccess(result.dataOrNull!));
      return;
    }

    emit(UpcomingMoviesFailure(
      result.failureOrNull?.message ?? 'Unexpected error occurred',
    ));
  }
}
