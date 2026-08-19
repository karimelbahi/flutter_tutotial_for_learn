import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_top_rated_movies.dart';
import 'top_rated_movies_state.dart';

/// Loads TMDB top-rated movies for the home horizontal row.
class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  TopRatedMoviesCubit(this._getTopRatedMovies)
      : super(const TopRatedMoviesInitial());

  final GetTopRatedMovies _getTopRatedMovies;

  Future<void> load() async {
    emit(const TopRatedMoviesLoading());

    final result = await _getTopRatedMovies();

    if (result.isSuccess) {
      emit(TopRatedMoviesSuccess(result.dataOrNull!));
      return;
    }

    emit(TopRatedMoviesFailure(
      result.failureOrNull?.message ?? 'Unexpected error occurred',
    ));
  }
}
