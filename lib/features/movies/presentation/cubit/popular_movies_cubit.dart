import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/refresh_popular_movies.dart';
import '../../domain/usecases/watch_popular_movies.dart';
import '../utils/error_messages.dart';
import 'popular_movies_state.dart';

/// Loads popular movies for the home carousel using **Cache-First SSOT**.
///
/// ## Flow (Principle VI)
///
/// ```
/// load()
///   ├─ subscribe WatchPopularMovies()  → emit cached Success immediately
///   └─ call RefreshPopularMovies()     → network → Hive → stream re-emits
/// ```
///
/// The Cubit never calls repository, Hive, or TMDB directly — only use cases.
class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  PopularMoviesCubit(
    this._watchPopularMovies,
    this._refreshPopularMovies,
  ) : super(const PopularMoviesInitial());

  final WatchPopularMovies _watchPopularMovies;
  final RefreshPopularMovies _refreshPopularMovies;

  StreamSubscription<List<Movie>>? _subscription;
  var _hasCache = false;
  var _isRefreshing = false;
  var _lastRefreshFailed = false;

  Future<void> load() async {
    await _subscription?.cancel();

    // Step A — listen to local SSOT stream first (cache-first).
    _subscription = _watchPopularMovies().listen(
      _onMoviesFromCache,
      onError: (_) {
        if (!_hasCache) {
          emit(PopularMoviesFailure(localizedFailureMessage(null)));
        }
      },
    );

    // Step B — background network refresh writes Hive; stream listener updates UI.
    await _refresh();
  }

  void _onMoviesFromCache(List<Movie> movies) {
    _hasCache = movies.isNotEmpty;

    if (!_hasCache) {
      // Cold cache: keep spinner until refresh succeeds or fails.
      if (state is! PopularMoviesFailure) {
        emit(const PopularMoviesLoading());
      }
      return;
    }

    emit(
      PopularMoviesSuccess(
        movies,
        isStale: _lastRefreshFailed,
        isRefreshing: _isRefreshing,
      ),
    );
  }

  Future<void> _refresh() async {
    _isRefreshing = true;
    _emitRefreshingFlag();

    final result = await _refreshPopularMovies();

    _isRefreshing = false;
    _lastRefreshFailed = result.isFailure;

    if (result.isFailure && !_hasCache) {
      emit(
        PopularMoviesFailure(
          localizedFailureMessage(result.failureOrNull?.message),
        ),
      );
      return;
    }

    // Refresh failed but cache exists → update stale flag on current Success.
    // Refresh succeeded → Hive watch stream will emit fresh data automatically.
    if (result.isFailure && _hasCache) {
      _emitRefreshingFlag();
    }
  }

  /// Updates `isRefreshing` / `isStale` on an existing Success without
  /// changing the movie list (used during background refresh).
  void _emitRefreshingFlag() {
    final current = state;
    if (current is! PopularMoviesSuccess) return;

    emit(
      PopularMoviesSuccess(
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
