# Feature Specification: Cache-First Single Source of Truth (SSOT)

**Feature Branch**: `feature/cache-first-ssot-architecture`

**Spec ID**: `005-cache-first-ssot`

**Created**: 2026-08-20

**Status**: Draft — awaiting approval

**Input**: Implement a robust Cache-First, SSOT local persistence pattern. UI reads only from local cache (Hive). Network fetches write to local cache and trigger reactive UI updates. Zero flicker on revisit; graceful offline with cached data.

---

## Constitutional Alignment

This spec implements **Constitution Principle VI — Cache-First SSOT** (see `.specify/memory/constitution.md`).

| Rule | Requirement |
|------|-------------|
| SSOT | Hive local store is the authoritative read source for UI-bound movie data |
| Write path | Network → LocalDataSource → Hive (never UI ← Network directly) |
| Read path | UI ← Cubit ← UseCase ← Repository.watch*() ← Hive |
| Reactivity | Repository exposes `Stream`/`watch` APIs backed by Hive box listeners |
| Flicker | Cached data emitted before network refresh completes |
| Errors | Network failure with valid cache → show cached data + stale/offline indicator |
| State mgmt | **Cubit only** — no Riverpod; streams consumed inside Cubits |
| Search v1 | Network-first (queries are user-specific; no stale search cache in v1) |

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Instant Home Feed on Reopen (Priority: P1)

As a user, I want the home screen to show the last loaded movies immediately when I open the app so I never stare at a blank screen.

**Why this priority**: Core offline/instant UX benefit of cache-first architecture.

**Independent Test**: Load home with network, kill app, enable airplane mode, reopen — carousel and rows show cached movies without spinner-only blank state.

**Acceptance Scenarios**:

1. **Given** cached popular movies exist, **When** the user opens home, **Then** carousel renders cached movies within 300ms without waiting for network.
2. **Given** cached data is shown, **When** network refresh succeeds, **Then** UI updates seamlessly without clearing to empty/loading.
3. **Given** no cache and no network, **When** home loads, **Then** user sees error state with retry (current behavior preserved).

---

### User Story 2 — Offline Browse with Stale Data (Priority: P1)

As a user, I want to browse previously loaded content offline so the app remains useful without connectivity.

**Acceptance Scenarios**:

1. **Given** the user viewed home and detail while online, **When** network is unavailable, **Then** home sections and previously opened movie detail still display from cache.
2. **Given** cached data is stale (> TTL), **When** network fails, **Then** cached data still displays with a non-blocking stale/offline banner or indicator.
3. **Given** network returns after offline, **When** refresh runs, **Then** cache and UI update automatically.

---

### User Story 3 — Detail Screen Cache (Priority: P2)

As a user, I want movie detail I opened before to load instantly when I tap the same movie again.

**Acceptance Scenarios**:

1. **Given** movie detail was fetched before, **When** user opens same `movieId`, **Then** detail/cast/similar sections show cached data first.
2. **Given** cache exists, **When** network refresh updates detail, **Then** sections update independently without full-screen reload flicker.

---

### User Story 4 — Search Remains Fresh (Priority: P3)

As a user, I want search results to reflect my current query from TMDB, not stale cached searches.

**Acceptance Scenarios**:

1. **Given** user types a search query, **When** results load, **Then** data comes from network (search is **network-first**, not cache-first in v1).
2. **Given** search fails offline, **When** no network, **Then** localized error shown (no fake cached search results).

---

### Edge Cases

- First launch (empty cache): show loading, fetch network, persist, display (same as today).
- Cache corruption / parse failure: clear affected box, fall back to network-only for that key.
- Genre switch: each genre has isolated cache key; switching tabs reads correct cached slice.
- TTL expired + offline: serve stale cache with indicator; do not wipe UI.
- Concurrent refresh: only latest refresh writes (stale network response guard, mirroring existing cubit guards).

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST initialize Hive at app startup via `HiveService` in `core/storage/`.
- **FR-002**: System MUST persist home list data (popular, genre, top rated, upcoming) to Hive after successful network fetch.
- **FR-003**: System MUST expose repository `watch*` stream methods that emit cached entities from Hive.
- **FR-004**: Cubits MUST subscribe to repository watch streams and emit UI state from local data first.
- **FR-005**: Repository refresh methods MUST fetch network → map → write Hive → (stream auto-emits).
- **FR-006**: On network error with non-empty cache, system MUST emit cached success state (not failure-only blank).
- **FR-007**: System MUST persist movie detail, cast, and similar movies by `movieId` with independent cache keys.
- **FR-008**: System MUST store cache metadata (fetchedAt, optional TTL) per cache key.
- **FR-009**: Search MUST remain network-first in v1 (documented exception to cache-first).
- **FR-010**: All Hive models MUST map to existing domain entities before reaching Cubits.
- **FR-011**: Existing Retrofit/TmdbApi endpoints MUST remain the network source (no raw Dio in features).

### Non-Functional Requirements

- **NFR-001**: No visible full-screen flicker when transitioning cached → refreshed data on home/detail.
- **NFR-002**: Repository unit tests for cache-hit, cache-miss, and offline-with-cache paths.
- **NFR-003**: `dart analyze lib/` clean; existing widget/cubit tests pass (update fakes as needed).

### Key Entities (cache domain)

| Cache key / box | Content | TTL (default) |
|-----------------|---------|-----------------|
| `popular_movies` | `List<Movie>` | 6 hours |
| `top_rated_movies` | `List<Movie>` | 6 hours |
| `upcoming_movies` | `List<Movie>` | 6 hours |
| `genre_movies_{id}` | `List<Movie>` | 6 hours |
| `movie_detail_{id}` | `MovieDetail` | 24 hours |
| `movie_cast_{id}` | `List<CastMember>` | 24 hours |
| `similar_movies_{id}` | `List<Movie>` | 24 hours |
| `cache_metadata` | timestamps per key | — |

---

## Success Criteria *(mandatory)*

- **SC-001**: Home screen shows cached content on cold start when cache exists, before network completes.
- **SC-002**: Airplane mode after prior online session — home lists remain visible from cache.
- **SC-003**: 100% of Cubit UI states for home/detail originate from repository watch streams (not direct network returns).
- **SC-004**: Search behavior unchanged (network-first) — no regression in search tests.
- **SC-005**: `flutter test` passes; new repository/cache tests added.

---

## Assumptions

- **Hive** is the local database (already in constitution; not Isar/Sqflite for v1).
- Reactive mechanism uses **Hive `Box.watch()`** + repository `Stream` APIs consumed by **Cubits** (not Riverpod).
- TTL defaults are configurable constants in `core/storage/cache_config.dart`.
- Phase 11.1 in `implementation-plan.md` is superseded by this spec for structured cache work.
- Pull-to-refresh and favorites are out of scope (future specs).

---

## Out of Scope (v1)

- Search query caching / recent searches Hive box
- Favorites / watchlist
- Background sync workers
- Isar/Sqflite migration
- Locale-persisted cache invalidation on language change (TMDB language param stays `en-US` as today)
