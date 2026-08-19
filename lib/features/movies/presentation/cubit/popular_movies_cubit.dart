import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_popular_movies.dart';
import 'popular_movies_state.dart';

/// Loads TMDB popular movies for the home carousel banner.
///
/// Flow: `load()` → [GetPopularMovies] use case → emit Loading / Success / Failure.
/// The Cubit never calls the repository or API directly.
class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  PopularMoviesCubit(this._getPopularMovies)
      : super(const PopularMoviesInitial());

  final GetPopularMovies _getPopularMovies;

  Future<void> load() async {
    emit(const PopularMoviesLoading());

    final result = await _getPopularMovies();

    if (result.isSuccess) {
      emit(PopularMoviesSuccess(result.dataOrNull!));
      return;
    }

    emit(PopularMoviesFailure(
      result.failureOrNull?.message ?? 'Unexpected error occurred',
    ));
  }
}
