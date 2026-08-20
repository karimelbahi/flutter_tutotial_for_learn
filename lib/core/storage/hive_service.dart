import 'package:hive_flutter/hive_flutter.dart';

/// Bootstraps Hive and exposes opened boxes to the data layer.
///
/// ## Cache-First SSOT role
///
/// In our architecture, **Hive is the Single Source of Truth** for UI data:
/// - Network responses are written **into** these boxes (never straight to UI).
/// - UI Cubits will **watch** box changes and rebuild when cache updates.
///
/// ## Singleton pattern
///
/// Same idea as [DioFactory]: configure once in `main()`, then read boxes
/// anywhere via `HiveService.instance`.
///
/// ## Box layout (spec 005)
///
/// | Box              | What it stores                          |
/// |------------------|-----------------------------------------|
/// | `movies_lists`   | Home rows keyed by [CacheKeys]          |
/// | `movie_details`  | One detail object per movie id            |
/// | `movie_cast`     | Cast list per movie id                  |
/// | `similar_movies` | Similar list per movie id               |
/// | `cache_metadata` | [CacheMetadata] timestamps per cache key  |
class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();

  // Internal box names — only this class needs to know them.
  static const _moviesListsBox = 'movies_lists';
  static const _movieDetailsBox = 'movie_details';
  static const _movieCastBox = 'movie_cast';
  static const _similarMoviesBox = 'similar_movies';
  static const _cacheMetadataBox = 'cache_metadata';

  var _isInitialized = false;

  /// Call once before `runApp` (see `main.dart`).
  ///
  /// `Hive.initFlutter()` picks a platform-specific directory so data survives
  /// app restarts — unlike an in-memory map.
  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // We use `dynamic` values (JSON-like maps/lists) in v1 — no code-generated
    // Hive adapters yet. LocalDataSource will encode/decode models manually.
    await Future.wait([
      Hive.openBox<dynamic>(_moviesListsBox),
      Hive.openBox<dynamic>(_movieDetailsBox),
      Hive.openBox<dynamic>(_movieCastBox),
      Hive.openBox<dynamic>(_similarMoviesBox),
      Hive.openBox<dynamic>(_cacheMetadataBox),
    ]);

    _isInitialized = true;
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'HiveService is not initialized. Call HiveService.instance.init() '
        'in main() before using cache boxes.',
      );
    }
  }

  /// Home carousel + horizontal rows (popular, genre tabs, etc.).
  Box<dynamic> get moviesListsBox {
    _ensureInitialized();
    return Hive.box<dynamic>(_moviesListsBox);
  }

  /// Full TMDB detail payload for one movie.
  Box<dynamic> get movieDetailsBox {
    _ensureInitialized();
    return Hive.box<dynamic>(_movieDetailsBox);
  }

  /// Credits / cast list for one movie.
  Box<dynamic> get movieCastBox {
    _ensureInitialized();
    return Hive.box<dynamic>(_movieCastBox);
  }

  /// "Similar movies" row for one movie.
  Box<dynamic> get similarMoviesBox {
    _ensureInitialized();
    return Hive.box<dynamic>(_similarMoviesBox);
  }

  /// Fetch timestamps — pairs with any key in the boxes above.
  Box<dynamic> get cacheMetadataBox {
    _ensureInitialized();
    return Hive.box<dynamic>(_cacheMetadataBox);
  }
}
