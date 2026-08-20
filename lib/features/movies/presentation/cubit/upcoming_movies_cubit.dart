import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/refresh_upcoming_movies.dart';
import '../../domain/usecases/watch_upcoming_movies.dart';
import '../utils/error_messages.dart';
import 'cache_first_load_helper.dart';
import 'upcoming_movies_state.dart';

/// Loads upcoming movies using **Cache-First SSOT** (same pattern as popular).
class UpcomingMoviesCubit extends Cubit<UpcomingMoviesState> {
  UpcomingMoviesCubit(
    this._watchUpcomingMovies,
    this._refreshUpcomingMovies,
  ) : super(const UpcomingMoviesInitial());

  final WatchUpcomingMovies _watchUpcomingMovies;
  final RefreshUpcomingMovies _refreshUpcomingMovies;

  StreamSubscription<List<Movie>>? _subscription;
  var _hasCache = false;
  var _isRefreshing = false;
  var _lastRefreshFailed = false;

  Future<void> load() async {
    await _subscription?.cancel();

    _subscription = await subscribeCacheWatch<List<Movie>>(
      watch: _watchUpcomingMovies(),
      onData: _onMoviesFromCache,
      onError: (_) {
        if (!_hasCache) {
          emit(UpcomingMoviesFailure(localizedFailureMessage(null)));
        }
      },
    );

    await _refresh();
  }

  void _onMoviesFromCache(List<Movie> movies) {
    _hasCache = movies.isNotEmpty;

    if (!_hasCache) {
      emit(const UpcomingMoviesLoading());
      return;
    }

    emit(
      UpcomingMoviesSuccess(
        movies,
        isStale: _lastRefreshFailed,
        isRefreshing: _isRefreshing,
      ),
    );
  }

  Future<void> _refresh() async {
    _isRefreshing = true;
    _emitRefreshingFlag();

    final result = await _refreshUpcomingMovies();

    _isRefreshing = false;
    _lastRefreshFailed = result.isFailure;

    if (result.isFailure && !_hasCache) {
      emit(
        UpcomingMoviesFailure(
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
    if (current is! UpcomingMoviesSuccess) return;

    emit(
      UpcomingMoviesSuccess(
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
