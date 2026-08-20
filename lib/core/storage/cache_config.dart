/// Time-to-live (TTL) rules for cached TMDB data.
///
/// **Soft TTL** means:
/// - Expired cache is *still shown* when offline (better UX than a blank screen).
/// - When online, we attempt a background refresh anyway.
///
/// These values live in one place so we can tune them without hunting through
/// repository code.
abstract final class CacheConfig {
  /// How long home rows (popular, genre, top rated, upcoming) stay "fresh".
  static const Duration homeListsTtl = Duration(hours: 6);

  /// Detail, cast, and similar sections change less often → longer TTL.
  static const Duration movieDetailTtl = Duration(hours: 24);
}
