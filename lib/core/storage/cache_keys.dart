/// Human-readable keys for Hive boxes.
///
/// **Why a separate file?**
/// Centralizing keys prevents typos (`'populr'` vs `'popular'`) and makes it
/// easy to see every cache slot the app uses.
///
/// Used by [MovieLocalDataSource] (next step) and [CacheMetadata] lookups.
abstract final class CacheKeys {
  // ── Home list slices (stored in the `movies_lists` Hive box) ─────────────

  static const popular = 'popular';
  static const topRated = 'top_rated';
  static const upcoming = 'upcoming';

  /// One cache entry per TMDB genre tab, e.g. `genre_28` for Action.
  static String genre(int genreId) => 'genre_$genreId';

  // ── Per-movie entries (movie id as string key) ───────────────────────────

  static String movieDetail(int movieId) => '$movieId';
  static String movieCast(int movieId) => '$movieId';
  static String similarMovies(int movieId) => '$movieId';
}
