# Research: Cache-First SSOT

**Feature**: 005-cache-first-ssot | **Date**: 2026-08-20

## Decision Log

### 1. Local database: Hive

**Decision**: Use `hive` + `hive_flutter` as mandated by constitution and `docs/architecture.md`.

**Rationale**: Already documented stack; lightweight; `Box.watch()` provides reactive updates without extra stream boilerplate.

**Alternatives considered**:
- **Isar** — stronger query API but new dependency, not in constitution
- **Sqflite** — SQL overhead for simple key-value movie lists
- **SharedPreferences** — unsuitable for structured lists/detail objects

---

### 2. Reactivity: Hive watch → Repository Stream → Cubit

**Decision**: Repository exposes `Stream<T>` methods; Cubits subscribe with `StreamSubscription`; cancel in `close()`.

**Rationale**: Aligns with constitution Cubit-only rule; avoids introducing Riverpod/StateNotifier; keeps reactivity at data boundary.

**Alternatives considered**:
- **Cubit emitting from refresh callback only** — no true SSOT; UI would still depend on network timing
- **Riverpod StreamProvider** — violates Cubit-only principle

---

### 3. Serialization: JSON maps in Hive (v1)

**Decision**: Store `Map<String, dynamic>` / `List` via existing model `fromJson`/`toJson` rather than `@HiveType` code generation in v1.

**Rationale**: Reuses TMDB model parsing; faster to ship; migration path to typed adapters later if needed.

**Alternatives considered**:
- **@HiveType adapters** — better performance, more build_runner surface area for first iteration

---

### 4. Search: network-first exception

**Decision**: `SearchMoviesCubit` keeps current `Future<Result>` network-only path; no search cache in v1.

**Rationale**: Search queries are ephemeral and user-specific; stale search results harm UX; spec 002 did not require search offline.

**Alternatives considered**:
- **Cache last N queries** — deferred to future spec

---

### 5. TTL strategy

**Decision**: Soft TTL via `CacheMetadata.fetchedAt`; expired cache still served offline with `isStale` flag; refresh attempted when online.

**Rationale**: Matches "zero flicker" requirement — never wipe UI on TTL expiry while offline.

**Defaults** (see `cache_config.dart`):
- Home lists: 6 hours
- Detail/cast/similar: 24 hours

---

### 6. Loading state behavior

**Decision**: Emit `Loading` only when cache is **empty** and refresh in flight. If cache has data, stay on `Success` with optional `isRefreshing: true`.

**Rationale**: Eliminates carousel blank flash on revisit.

---

### 7. Box layout: multi-box vs single box

**Decision**: Separate boxes by entity shape (`movies_lists`, `movie_details`, `movie_cast`, `similar_movies`, `cache_metadata`).

**Rationale**: Clearer key namespaces; avoids one giant box; matches feature data boundaries.

---

## Reference Patterns

- **Android Room + Flow**: local DB as SSOT, network sync writes DB, UI collects Flow
- **iOS Core Data + NSFetchedResultsController**: same pattern
- **Flutter**: Hive watch ≈ Room Flow for this app's scale

## Open Questions (resolved for v1)

| Question | Resolution |
|----------|------------|
| Invalidate cache on locale change? | No — TMDB calls use fixed `en-US` today |
| Pull-to-refresh? | Out of scope; manual retry triggers refresh |
| Favorites box? | Out of scope (Phase 11 future) |
