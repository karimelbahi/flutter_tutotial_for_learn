import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/refresh_top_rated_movies.dart';
import '../../domain/usecases/watch_top_rated_movies.dart';
import '../utils/error_messages.dart';
import 'top_rated_movies_state.dart';

/// Loads top-rated movies using the same **Cache-First SSOT** pattern as
/// [PopularMoviesCubit] — see that class for the full flow diagram.
class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  TopRatedMoviesCubit(
    this._watchTopRatedMovies,
    this._refreshTopRatedMovies,
  ) : super(const TopRatedMoviesInitial());

  final WatchTopRatedMovies _watchTopRatedMovies;
  final RefreshTopRatedMovies _refreshTopRatedMovies;

  StreamSubscription<List<Movie>>? _subscription;
  var _hasCache = false;
  var _isRefreshing = false;
  var _lastRefreshFailed = false;

  Future<void> load() async {
    await _subscription?.cancel();

    _subscription = _watchTopRatedMovies().listen(
      _onMoviesFromCache,
      onError: (_) {
        if (!_hasCache) {
          emit(TopRatedMoviesFailure(localizedFailureMessage(null)));
        }
      },
    );

    await _refresh();
  }

  void _onMoviesFromCache(List<Movie> movies) {
    _hasCache = movies.isNotEmpty;

    if (!_hasCache) {
      if (state is! TopRatedMoviesFailure) {
        emit(const TopRatedMoviesLoading());
      }
      return;
    }

    emit(
      TopRatedMoviesSuccess(
        movies,
        isStale: _lastRefreshFailed,
        isRefreshing: _isRefreshing,
      ),
    );
  }

  Future<void> _refresh() async {
    _isRefreshing = true;
    _emitRefreshingFlag();

    final result = await _refreshTopRatedMovies();

    _isRefreshing = false;
    _lastRefreshFailed = result.isFailure;

    if (result.isFailure && !_hasCache) {
      emit(
        TopRatedMoviesFailure(
          localizedFailureMessage(result.failureOrNull?.message),
        ),
      );
      return;
    }

    if (result.isFailure && _hasCache) {
      _emitRefreshingFlag();
    }
  }

  void _emitRefreshingFlag() {
    final current = state;
    if (current is! TopRatedMoviesSuccess) return;

    emit(
      TopRatedMoviesSuccess(
        current.movies,
        isStale: _lastRefreshFailed,
        isRefreshing: _isRefreshing,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
