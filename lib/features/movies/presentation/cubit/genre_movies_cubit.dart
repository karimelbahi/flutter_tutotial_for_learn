import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/refresh_genre_movies.dart';
import '../../domain/usecases/watch_genre_movies.dart';
import '../utils/error_messages.dart';
import 'genre_movies_state.dart';

/// Loads movies for the selected genre tab using **Cache-First SSOT**.
///
/// ## Extra complexity vs popular/top-rated
///
/// Each genre has its **own Hive key** (`genre_28`, `genre_35`, …).
/// When the user switches tabs we:
/// 1. Cancel the old stream subscription
/// 2. Subscribe to the new genre's watch stream
/// 3. Refresh that genre in the background
///
/// [_latestGenreId] prevents stale tab data from overwriting a newer selection.
class GenreMoviesCubit extends Cubit<GenreMoviesState> {
  GenreMoviesCubit(
    this._watchGenreMovies,
    this._refreshGenreMovies, {
    required int initialGenreId,
  })  : _latestGenreId = initialGenreId,
        super(GenreMoviesInitial(genreId: initialGenreId));

  final WatchGenreMovies _watchGenreMovies;
  final RefreshGenreMovies _refreshGenreMovies;

  int _latestGenreId;
  StreamSubscription<List<Movie>>? _subscription;
  var _hasCache = false;
  var _isRefreshing = false;
  var _lastRefreshFailed = false;

  Future<void> load(int genreId) async {
    _latestGenreId = genreId;
    // Each genre tab has its own cache — don't carry flags from the previous tab.
    _hasCache = false;
    _lastRefreshFailed = false;
    _isRefreshing = false;

    await _subscription?.cancel();

    // Listen to THIS genre's cache slice only.
    _subscription = _watchGenreMovies(genreId).listen(
      (movies) => _onMoviesFromCache(genreId, movies),
      onError: (_) {
        if (!_hasCache && genreId == _latestGenreId) {
          emit(
            GenreMoviesFailure(
              genreId: genreId,
              message: localizedFailureMessage(null),
            ),
          );
        }
      },
    );

    await _refresh(genreId);
  }

  void _onMoviesFromCache(int genreId, List<Movie> movies) {
    // User already switched tabs — ignore late events from the old stream.
    if (isClosed || genreId != _latestGenreId) return;

    _hasCache = movies.isNotEmpty;

    if (!_hasCache) {
      if (state is! GenreMoviesFailure) {
        emit(GenreMoviesLoading(genreId: genreId));
      }
      return;
    }

    emit(
      GenreMoviesSuccess(
        genreId: genreId,
        movies: movies,
        isStale: _lastRefreshFailed,
        isRefreshing: _isRefreshing,
      ),
    );
  }

  Future<void> _refresh(int genreId) async {
    if (genreId != _latestGenreId) return;

    _isRefreshing = true;
    _emitRefreshingFlag(genreId);

    final result = await _refreshGenreMovies(genreId);

    if (genreId != _latestGenreId) return;

    _isRefreshing = false;
    _lastRefreshFailed = result.isFailure;

    if (result.isFailure && !_hasCache) {
      emit(
        GenreMoviesFailure(
          genreId: genreId,
          message: localizedFailureMessage(result.failureOrNull?.message),
        ),
      );
      return;
    }

    if (result.isFailure && _hasCache) {
      _emitRefreshingFlag(genreId);
    }
  }

  void _emitRefreshingFlag(int genreId) {
    if (genreId != _latestGenreId) return;

    final current = state;
    if (current is! GenreMoviesSuccess) return;

    emit(
      GenreMoviesSuccess(
        genreId: genreId,
        movies: current.movies,
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
