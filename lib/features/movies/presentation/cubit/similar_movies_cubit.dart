import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/refresh_similar_movies.dart';
import '../../domain/usecases/watch_similar_movies.dart';
import '../utils/error_messages.dart';
import 'cache_first_load_helper.dart';
import 'similar_movies_state.dart';

/// Loads similar movies row using **Cache-First SSOT**.
class SimilarMoviesCubit extends Cubit<SimilarMoviesState> {
  SimilarMoviesCubit(
    this._watchSimilarMovies,
    this._refreshSimilarMovies,
  ) : super(const SimilarMoviesInitial());

  final WatchSimilarMovies _watchSimilarMovies;
  final RefreshSimilarMovies _refreshSimilarMovies;

  int _latestMovieId = 0;
  StreamSubscription<List<Movie>>? _subscription;
  var _hasCache = false;
  var _isRefreshing = false;
  var _lastRefreshFailed = false;

  Future<void> load(int movieId) async {
    _latestMovieId = movieId;
    _hasCache = false;
    _lastRefreshFailed = false;
    _isRefreshing = false;

    await _subscription?.cancel();

    _subscription = await subscribeCacheWatch<List<Movie>>(
      watch: _watchSimilarMovies(movieId),
      onData: (movies) => _onSimilarFromCache(movieId, movies),
      onError: (_) {
        if (!_hasCache && movieId == _latestMovieId) {
          emit(
            SimilarMoviesFailure(
              message: localizedFailureMessage(null),
              movieId: movieId,
            ),
          );
        }
      },
    );

    await _refresh(movieId);
  }

  void _onSimilarFromCache(int movieId, List<Movie> movies) {
    if (isClosed || movieId != _latestMovieId) return;

    _hasCache = movies.isNotEmpty;

    if (!_hasCache) {
      emit(const SimilarMoviesLoading());
      return;
    }

    emit(
      SimilarMoviesSuccess(
        movies,
        isStale: _lastRefreshFailed,
        isRefreshing: _isRefreshing,
      ),
    );
  }

  Future<void> _refresh(int movieId) async {
    if (movieId != _latestMovieId) return;

    _isRefreshing = true;
    _emitRefreshingFlag(movieId);

    final result = await _refreshSimilarMovies(movieId);

    if (movieId != _latestMovieId) return;

    _isRefreshing = false;
    _lastRefreshFailed = result.isFailure;

    if (result.isFailure && !_hasCache) {
      emit(
        SimilarMoviesFailure(
          message: localizedFailureMessage(result.failureOrNull?.message),
          movieId: movieId,
        ),
      );
      return;
    }

    if (result.isFailure && _hasCache) {
      _emitRefreshingFlag(movieId);
    }
  }

  void _emitRefreshingFlag(int movieId) {
    if (movieId != _latestMovieId) return;

    final current = state;
    if (current is! SimilarMoviesSuccess) return;

    emit(
      SimilarMoviesSuccess(
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
