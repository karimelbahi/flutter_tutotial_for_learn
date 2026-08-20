import 'dart:async';

import 'package:hive/hive.dart';

import '../../../../core/storage/cache_keys.dart';
import '../../../../core/storage/cache_metadata.dart';
import '../../../../core/storage/hive_service.dart';
import '../models/movie_credits_model.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';

/// Reads and writes TMDB **models** in Hive — the local half of Cache-First SSOT.
///
/// ## Why a separate datasource from [MovieRemoteDataSource]?
///
/// | Remote datasource | Local datasource |
/// |-------------------|------------------|
/// | Talks to TMDB API | Talks to Hive boxes |
/// | Returns fresh network data | Returns cached + reactive streams |
/// | Called on **refresh** | Called on **watch** and after network save |
///
/// The **repository** (next step) coordinates both: refresh = remote → local,
/// watch = local stream → UI Cubit.
abstract class MovieLocalDataSource {
  // ── Home lists ───────────────────────────────────────────────────────────

  Future<void> savePopularMovies(List<MovieModel> movies);
  Stream<List<MovieModel>> watchPopularMovies();

  Future<void> saveTopRatedMovies(List<MovieModel> movies);
  Stream<List<MovieModel>> watchTopRatedMovies();

  Future<void> saveUpcomingMovies(List<MovieModel> movies);
  Stream<List<MovieModel>> watchUpcomingMovies();

  Future<void> saveMoviesByGenre(int genreId, List<MovieModel> movies);
  Stream<List<MovieModel>> watchMoviesByGenre(int genreId);

  // ── Movie detail sections ────────────────────────────────────────────────

  Future<void> saveMovieDetail(int movieId, MovieDetailModel detail);
  Stream<MovieDetailModel?> watchMovieDetail(int movieId);

  Future<void> saveMovieCast(int movieId, List<CastMemberModel> cast);
  Stream<List<CastMemberModel>> watchMovieCast(int movieId);

  Future<void> saveSimilarMovies(int movieId, List<MovieModel> movies);
  Stream<List<MovieModel>> watchSimilarMovies(int movieId);

  // ── Metadata (for stale/offline hints) ───────────────────────────────────

  CacheMetadata? getMetadata(String cacheKey);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  MovieLocalDataSourceImpl({HiveService? hiveService})
      : _hive = hiveService ?? HiveService.instance;

  final HiveService _hive;

  // ── Popular ──────────────────────────────────────────────────────────────

  @override
  Future<void> savePopularMovies(List<MovieModel> movies) {
    return _saveMovieList(CacheKeys.popular, movies);
  }

  @override
  Stream<List<MovieModel>> watchPopularMovies() {
    return _watchMovieList(CacheKeys.popular);
  }

  // ── Top rated ────────────────────────────────────────────────────────────

  @override
  Future<void> saveTopRatedMovies(List<MovieModel> movies) {
    return _saveMovieList(CacheKeys.topRated, movies);
  }

  @override
  Stream<List<MovieModel>> watchTopRatedMovies() {
    return _watchMovieList(CacheKeys.topRated);
  }

  // ── Upcoming ─────────────────────────────────────────────────────────────

  @override
  Future<void> saveUpcomingMovies(List<MovieModel> movies) {
    return _saveMovieList(CacheKeys.upcoming, movies);
  }

  @override
  Stream<List<MovieModel>> watchUpcomingMovies() {
    return _watchMovieList(CacheKeys.upcoming);
  }

  // ── Genre tab ────────────────────────────────────────────────────────────

  @override
  Future<void> saveMoviesByGenre(int genreId, List<MovieModel> movies) {
    return _saveMovieList(CacheKeys.genre(genreId), movies);
  }

  @override
  Stream<List<MovieModel>> watchMoviesByGenre(int genreId) {
    return _watchMovieList(CacheKeys.genre(genreId));
  }

  // ── Detail ───────────────────────────────────────────────────────────────

  @override
  Future<void> saveMovieDetail(int movieId, MovieDetailModel detail) {
    if (movieId <= 0) return Future.value();

    final key = CacheKeys.movieDetail(movieId);
    return _hive.movieDetailsBox.put(key, detail.toJson()).then((_) {
      _writeMetadata(key);
    });
  }

  @override
  Stream<MovieDetailModel?> watchMovieDetail(int movieId) {
    if (movieId <= 0) return Stream.value(null);

    final key = CacheKeys.movieDetail(movieId);
    return _watchBoxValue(
      box: _hive.movieDetailsBox,
      key: key,
      read: () => _readMovieDetail(key),
    );
  }

  // ── Cast ─────────────────────────────────────────────────────────────────

  @override
  Future<void> saveMovieCast(int movieId, List<CastMemberModel> cast) {
    if (movieId <= 0) return Future.value();

    final key = CacheKeys.movieCast(movieId);
    final jsonList = cast.map((member) => member.toJson()).toList();
    return _hive.movieCastBox.put(key, jsonList).then((_) {
      _writeMetadata(key);
    });
  }

  @override
  Stream<List<CastMemberModel>> watchMovieCast(int movieId) {
    if (movieId <= 0) return Stream.value(const []);

    final key = CacheKeys.movieCast(movieId);
    return _watchBoxValue(
      box: _hive.movieCastBox,
      key: key,
      read: () => _readCastList(key),
    );
  }

  // ── Similar ──────────────────────────────────────────────────────────────

  @override
  Future<void> saveSimilarMovies(int movieId, List<MovieModel> movies) {
    if (movieId <= 0) return Future.value();

    return _saveMovieList(CacheKeys.similarMovies(movieId), movies,
        box: _hive.similarMoviesBox);
  }

  @override
  Stream<List<MovieModel>> watchSimilarMovies(int movieId) {
    if (movieId <= 0) return Stream.value(const []);

    return _watchMovieList(
      CacheKeys.similarMovies(movieId),
      box: _hive.similarMoviesBox,
    );
  }

  @override
  CacheMetadata? getMetadata(String cacheKey) {
    final raw = _hive.cacheMetadataBox.get(cacheKey);
    if (raw is! Map) return null;

    try {
      return CacheMetadata.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      // Corrupt metadata — treat as missing rather than crashing the app.
      unawaited(_hive.cacheMetadataBox.delete(cacheKey));
      return null;
    }
  }

  // ── Shared helpers ───────────────────────────────────────────────────────

  Future<void> _saveMovieList(
    String cacheKey,
    List<MovieModel> movies, {
    Box<dynamic>? box,
  }) {
    final targetBox = box ?? _hive.moviesListsBox;
    final jsonList = movies.map((movie) => movie.toJson()).toList();
    return targetBox.put(cacheKey, jsonList).then((_) {
      _writeMetadata(cacheKey);
    });
  }

  Stream<List<MovieModel>> _watchMovieList(
    String cacheKey, {
    Box<dynamic>? box,
  }) {
    final targetBox = box ?? _hive.moviesListsBox;
    return _watchBoxValue(
      box: targetBox,
      key: cacheKey,
      read: () => _readMovieList(cacheKey, box: targetBox),
    );
  }

  /// Generic "SSOT stream" pattern used by every watch method.
  ///
  /// 1. **Yield current cache** immediately (cache-first — no waiting).
  /// 2. **Listen** to `box.watch(key:)` — Hive fires when that key changes.
  /// 3. Re-read and yield again so Cubits rebuild with fresh local data.
  Stream<T> _watchBoxValue<T>({
    required Box<dynamic> box,
    required String key,
    required T Function() read,
  }) async* {
    yield read();
    await for (final _ in box.watch(key: key)) {
      yield read();
    }
  }

  List<MovieModel> _readMovieList(String cacheKey, {Box<dynamic>? box}) {
    final targetBox = box ?? _hive.moviesListsBox;
    final raw = targetBox.get(cacheKey);
    if (raw == null) return const [];

    if (raw is! List) {
      _clearCorruptEntry(targetBox, cacheKey);
      return const [];
    }

    try {
      return raw
          .map((item) => MovieModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      _clearCorruptEntry(targetBox, cacheKey);
      return const [];
    }
  }

  MovieDetailModel? _readMovieDetail(String cacheKey) {
    final raw = _hive.movieDetailsBox.get(cacheKey);
    if (raw == null) return null;

    if (raw is! Map) {
      _clearCorruptEntry(_hive.movieDetailsBox, cacheKey);
      return null;
    }

    try {
      return MovieDetailModel.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      _clearCorruptEntry(_hive.movieDetailsBox, cacheKey);
      return null;
    }
  }

  List<CastMemberModel> _readCastList(String cacheKey) {
    final raw = _hive.movieCastBox.get(cacheKey);
    if (raw == null) return const [];

    if (raw is! List) {
      _clearCorruptEntry(_hive.movieCastBox, cacheKey);
      return const [];
    }

    try {
      return raw
          .map(
            (item) =>
                CastMemberModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (_) {
      _clearCorruptEntry(_hive.movieCastBox, cacheKey);
      return const [];
    }
  }

  void _writeMetadata(String cacheKey) {
    final metadata = CacheMetadata(fetchedAt: DateTime.now());
    unawaited(
      _hive.cacheMetadataBox.put(cacheKey, metadata.toJson()),
    );
  }

  void _clearCorruptEntry(Box<dynamic> box, String cacheKey) {
    unawaited(box.delete(cacheKey));
    unawaited(_hive.cacheMetadataBox.delete(cacheKey));
  }
}
