# Implementation Validation: Cache-First SSOT

**Purpose**: Confirm `005-cache-first-ssot` is built and validated  
**Validated**: 2026-08-20  
**Feature**: [spec.md](../spec.md) · [quickstart.md](../quickstart.md)

## Static analysis & tests

- [x] `dart analyze lib/` — no issues
- [x] `flutter test` — all tests pass (includes repository + cubit cache-first tests)
- [x] `MovieRepositoryImpl` integration tests — cold cache, refresh writes Hive, offline-with-cache

## Implementation phases (tasks T006–T049)

- [x] T006–T011 — Hive dependencies, `HiveService`, cache config/metadata
- [x] T012–T017 — `MovieLocalDataSource` save/watch streams
- [x] T018–T025 — Popular movies vertical slice (repository watch/refresh + cubit)
- [x] T026–T033 — Top rated, upcoming, genre tabs cache-first
- [x] T034–T040 — Detail, cast, similar cache-first
- [x] T041–T043 — Stale/offline banner, i18n, search network-first documented
- [x] T044–T048 — Repository tests, `@Deprecated` legacy `get*`, architecture docs
- [ ] T049 — Manual quickstart (online → offline → online) — run on device

## Spec acceptance (P1–P3)

- [x] P1 — Home shows cached content on reopen; offline browse with stale banner
- [x] P2 — Detail/cast/similar cache by `movieId`; instant revisit
- [x] P3 — Search remains network-first (no fake cached search results)

## Cubit SSOT checklist

- [x] `PopularMoviesCubit` — watch + refresh, `isStale` / `isRefreshing`
- [x] `TopRatedMoviesCubit` / `UpcomingMoviesCubit` — same pattern
- [x] `GenreMoviesCubit` — resubscribe on tab change + stale guard
- [x] `MovieDetailCubit` / `MovieCastCubit` / `SimilarMoviesCubit` — per-`movieId` cache
- [x] `SearchMoviesCubit` — unchanged (network-only)

## Manual validation (recommended — T049)

- [ ] First launch online — home + detail load normally
- [ ] Second launch — home carousel appears before network completes
- [ ] Airplane mode after prior session — home + visited detail show cache + offline banner
- [ ] Fresh install offline — error states with retry (no fake data)
- [ ] Genre tab switch offline — each visited tab shows its cached slice
- [ ] Search offline — error (not cached results)

## Notes

- Legacy `get*` repository methods marked `@Deprecated`; use cases retained for reference.
- Pull-to-refresh, favorites, and search cache deferred to future specs.
- Locale change does not invalidate TMDB cache (API language remains `en-US`).
