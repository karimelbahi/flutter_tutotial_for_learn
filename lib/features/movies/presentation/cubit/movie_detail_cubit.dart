import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_detail.dart';
import '../../domain/usecases/refresh_movie_detail.dart';
import '../../domain/usecases/watch_movie_detail.dart';
import '../utils/error_messages.dart';
import 'movie_detail_state.dart';

/// Loads movie detail using **Cache-First SSOT**.
///
/// Same pattern as [GenreMoviesCubit]: each [movieId] has its own Hive entry.
/// When the user taps a similar movie, we resubscribe and ignore late events
/// from the previous id via [_latestMovieId].
class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit(
    this._watchMovieDetail,
    this._refreshMovieDetail,
  ) : super(const MovieDetailInitial());

  final WatchMovieDetail _watchMovieDetail;
  final RefreshMovieDetail _refreshMovieDetail;

  int _latestMovieId = 0;
  StreamSubscription<MovieDetail?>? _subscription;
  var _hasCache = false;
  var _isRefreshing = false;
  var _lastRefreshFailed = false;

  Future<void> load(int movieId) async {
    _latestMovieId = movieId;
    _hasCache = false;
    _lastRefreshFailed = false;
    _isRefreshing = false;

    await _subscription?.cancel();

    _subscription = _watchMovieDetail(movieId).listen(
      (detail) => _onDetailFromCache(movieId, detail),
      onError: (_) {
        if (!_hasCache && movieId == _latestMovieId) {
          emit(
            MovieDetailFailure(
              message: localizedFailureMessage(null),
              movieId: movieId,
            ),
          );
        }
      },
    );

    await _refresh(movieId);
  }

  void _onDetailFromCache(int movieId, MovieDetail? detail) {
    if (isClosed || movieId != _latestMovieId) return;

    _hasCache = detail != null;

    if (!_hasCache) {
      if (state is! MovieDetailFailure) {
        emit(const MovieDetailLoading());
      }
      return;
    }

    emit(
      MovieDetailSuccess(
        detail!,
        isStale: _lastRefreshFailed,
        isRefreshing: _isRefreshing,
      ),
    );
  }

  Future<void> _refresh(int movieId) async {
    if (movieId != _latestMovieId) return;

    _isRefreshing = true;
    _emitRefreshingFlag(movieId);

    final result = await _refreshMovieDetail(movieId);

    if (movieId != _latestMovieId) return;

    _isRefreshing = false;
    _lastRefreshFailed = result.isFailure;

    if (result.isFailure && !_hasCache) {
      emit(
        MovieDetailFailure(
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
    if (current is! MovieDetailSuccess) return;

    emit(
      MovieDetailSuccess(
        current.detail,
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
