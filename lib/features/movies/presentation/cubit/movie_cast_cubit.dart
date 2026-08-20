import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cast_member.dart';
import '../../domain/usecases/refresh_movie_cast.dart';
import '../../domain/usecases/watch_movie_cast.dart';
import '../utils/error_messages.dart';
import 'cache_first_load_helper.dart';
import 'movie_cast_state.dart';

/// Loads cast independently from detail using **Cache-First SSOT**.
///
/// Cast and detail are separate Hive boxes — each section loads/refreshes
/// on its own schedule (FR-008 from spec 003).
class MovieCastCubit extends Cubit<MovieCastState> {
  MovieCastCubit(
    this._watchMovieCast,
    this._refreshMovieCast,
  ) : super(const MovieCastInitial());

  final WatchMovieCast _watchMovieCast;
  final RefreshMovieCast _refreshMovieCast;

  int _latestMovieId = 0;
  StreamSubscription<List<CastMember>>? _subscription;
  var _hasCache = false;
  var _isRefreshing = false;
  var _lastRefreshFailed = false;

  Future<void> load(int movieId) async {
    _latestMovieId = movieId;
    _hasCache = false;
    _lastRefreshFailed = false;
    _isRefreshing = false;

    await _subscription?.cancel();

    _subscription = await subscribeCacheWatch<List<CastMember>>(
      watch: _watchMovieCast(movieId),
      onData: (cast) => _onCastFromCache(movieId, cast),
      onError: (_) {
        if (!_hasCache && movieId == _latestMovieId) {
          emit(
            MovieCastFailure(
              message: localizedFailureMessage(null),
              movieId: movieId,
            ),
          );
        }
      },
    );

    await _refresh(movieId);
  }

  void _onCastFromCache(int movieId, List<CastMember> cast) {
    if (isClosed || movieId != _latestMovieId) return;

    _hasCache = cast.isNotEmpty;

    if (!_hasCache) {
      emit(const MovieCastLoading());
      return;
    }

    emit(
      MovieCastSuccess(
        cast,
        isStale: _lastRefreshFailed,
        isRefreshing: _isRefreshing,
      ),
    );
  }

  Future<void> _refresh(int movieId) async {
    if (movieId != _latestMovieId) return;

    _isRefreshing = true;
    _emitRefreshingFlag(movieId);

    final result = await _refreshMovieCast(movieId);

    if (movieId != _latestMovieId) return;

    _isRefreshing = false;
    _lastRefreshFailed = result.isFailure;

    if (result.isFailure && !_hasCache) {
      emit(
        MovieCastFailure(
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
    if (current is! MovieCastSuccess) return;

    emit(
      MovieCastSuccess(
        current.cast,
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
