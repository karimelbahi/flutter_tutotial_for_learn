/// Records *when* a cache entry was last fetched from TMDB.
///
/// Stored in the `cache_metadata` Hive box, using the **same key** as the
/// corresponding data entry (see [CacheKeys]).
///
/// Example flow:
/// 1. Network returns popular movies → save list to Hive.
/// 2. Save `CacheMetadata(fetchedAt: DateTime.now())` under key `popular`.
/// 3. Later, repository checks `isExpired(CacheConfig.homeListsTtl)` to
///    decide if UI should show a "stale / offline" hint.
class CacheMetadata {
  const CacheMetadata({required this.fetchedAt});

  final DateTime fetchedAt;

  /// Returns `true` when the entry is older than [ttl].
  ///
  /// Note: "expired" does **not** mean "delete" — we keep serving stale data
  /// offline per spec 005 (Cache-First SSOT).
  bool isExpired(Duration ttl) {
    return DateTime.now().difference(fetchedAt) > ttl;
  }

  /// Hive stores primitives/maps — we serialize [DateTime] as epoch milliseconds.
  Map<String, dynamic> toJson() => {
        'fetched_at_ms': fetchedAt.millisecondsSinceEpoch,
      };

  factory CacheMetadata.fromJson(Map<String, dynamic> json) {
    final ms = json['fetched_at_ms'];
    if (ms is! int) {
      throw FormatException('Invalid cache metadata: missing fetched_at_ms');
    }
    return CacheMetadata(fetchedAt: DateTime.fromMillisecondsSinceEpoch(ms));
  }
}
