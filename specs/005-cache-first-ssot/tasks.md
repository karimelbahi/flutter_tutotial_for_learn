---
description: "Task list for cache-first SSOT — one commit per task, sequential execution"
---

# Tasks: Cache-First Single Source of Truth (SSOT)

**Input**: Design documents from `/specs/005-cache-first-ssot/`

**Branch**: `feature/cache-first-ssot-architecture`

**Execution rule**: Complete tasks **in order**. After each task: run validation → commit → push → proceed.

**Commit prefix**: `feat(cache-ssot): <task description>`

## Format: `[ID] [P?] [Story] Description`

---

## Phase 0: Governance & Spec (complete before coding)

**Commit**: `docs(cache-ssot): add spec 005 cache-first SSOT artifacts`

- [x] T001 Update `.specify/memory/constitution.md` — add Principle VI Cache-First SSOT (v1.2.0)
- [x] T002 [P] Finalize `specs/005-cache-first-ssot/spec.md`
- [x] T003 [P] Finalize `specs/005-cache-first-ssot/plan.md`
- [x] T004 [P] Finalize `specs/005-cache-first-ssot/tasks.md`, `research.md`, `data-model.md`, `quickstart.md`
- [x] T005 **STOP — await user approval before T006**

---

## Phase 1: Core Hive Infrastructure

**Commit**: `feat(cache-ssot): add hive dependencies and HiveService`

- [x] T006 Add `hive` + `hive_flutter` to `pubspec.yaml`; run `flutter pub get`
- [x] T007 Create `lib/core/storage/cache_config.dart` — TTL constants per cache key type
- [x] T008 Create `lib/core/storage/cache_metadata.dart` — `CacheMetadata` model + `isExpired(ttl)` helper
- [x] T009 Create `lib/core/storage/hive_service.dart` — init, open boxes (`movies_lists`, `movie_details`, `movie_cast`, `similar_movies`, `cache_metadata`)
- [x] T010 Wire `HiveService.init()` in `lib/main.dart` before `runApp`
- [x] T011 Validate: `dart analyze lib/core/storage/`

---

## Phase 2: Local Data Layer

**Commit**: `feat(cache-ssot): add MovieLocalDataSource with watch streams`

- [x] T012 Add `toJson()` on `MovieModel`, `MovieDetailModel`, cast models (mirror `fromJson`)
- [x] T013 Create `lib/features/movies/data/datasources/movie_local_data_source.dart` — abstract + impl
- [x] T014 Implement list cache: save/get/watch for `popular`, `top_rated`, `upcoming`, `genre_{id}`
- [x] T015 Implement detail cache: save/get/watch for detail, cast, similar by `movieId`
- [x] T016 Implement metadata read/write per cache key; clear-on-corruption helper
- [x] T017 Validate: unit tests for local datasource save + watch emit

---

## Phase 3: Repository Contract & Popular Movies Vertical Slice (P1)

**Commit**: `feat(cache-ssot): extend MovieRepository with watch and refresh APIs`

- [x] T018 Extend `lib/features/movies/domain/repositories/movie_repository.dart` — watch* + refresh* methods
- [x] T019 Refactor `movie_repository_impl.dart` — inject local + remote datasources; implement popular watch/refresh
- [x] T020 Create `watch_popular_movies.dart` + `refresh_popular_movies.dart` use cases
- [x] T021 Update `movies_presentation_module.dart` / DI wiring for new use cases + local datasource

**Commit**: `feat(cache-ssot): migrate PopularMoviesCubit to cache-first streams`

- [x] T022 Extend `PopularMoviesState` — optional `isStale`, `isRefreshing`
- [x] T023 Refactor `PopularMoviesCubit` — subscribe watch stream, background refresh, cancel on close
- [x] T024 Update `PopularMoviesCubit` tests — cache-first: no loading flash when cache exists
- [x] T025 Manual quickstart: home carousel instant on second launch

---

## Phase 4: Remaining Home Lists (P1)

**Commit**: `feat(cache-ssot): cache-first top rated and upcoming movies`

- [x] T026 Add watch/refresh use cases for top rated + upcoming
- [x] T027 Implement repository watch/refresh for top rated + upcoming
- [x] T028 Refactor `TopRatedMoviesCubit` + `UpcomingMoviesCubit` to stream pattern
- [x] T029 Update cubit tests for top rated + upcoming

**Commit**: `feat(cache-ssot): cache-first genre movies by genre id`

- [x] T030 Add watch/refresh use cases for genre movies (parameterized by `genreId`)
- [x] T031 Implement repository watch/refresh for `genre_{id}`
- [x] T032 Refactor `GenreMoviesCubit` — resubscribe on genre tab change; cancel old subscription
- [x] T033 Update genre cubit tests

---

## Phase 5: Movie Detail Sections (P2)

**Commit**: `feat(cache-ssot): cache-first movie detail`

- [x] T034 Add watch/refresh use cases for movie detail
- [x] T035 Implement repository watch/refresh for detail
- [x] T036 Refactor `MovieDetailCubit` — stream + refresh; reload on `movieId` change

**Commit**: `feat(cache-ssot): cache-first cast and similar movies`

- [x] T037 Add watch/refresh use cases for cast + similar
- [x] T038 Implement repository watch/refresh for cast + similar
- [x] T039 Refactor `MovieCastCubit` + `SimilarMoviesCubit`
- [x] T040 Update detail-related cubit tests

---

## Phase 6: UX Polish & Search Exception (P3)

**Commit**: `feat(cache-ssot): add stale offline indicator and i18n keys`

- [x] T041 Add `cache.stale` / `cache.offline` keys to `en.json` + `ar.json`
- [x] T042 Add non-blocking stale banner/chip on home + detail when `isStale == true`
- [x] T043 Document search as network-first exception in repository + spec cross-ref; verify `SearchMoviesCubit` unchanged

---

## Phase 7: Cleanup, Tests & Documentation

**Commit**: `feat(cache-ssot): add repository integration tests`

- [x] T044 Add `movie_repository_impl` tests: cache hit, cache miss, offline-with-cache, refresh writes Hive
- [x] T045 Remove deprecated one-shot `getPopularMovies` / etc. from repository if all cubits migrated (or mark `@Deprecated` with removal note)

**Commit**: `feat(cache-ssot): update architecture docs and validation checklist`

- [x] T046 Update `docs/architecture.md` — SSOT data-flow diagram + Hive section
- [x] T047 Run `dart analyze lib/` + `flutter test` — all green
- [x] T048 Create `specs/005-cache-first-ssot/checklists/implementation-validation.md`
- [x] T049 Run quickstart manual validation (online → offline → online)

---

## Dependencies

```text
T001–T005 (approval gate)
  → T006–T011 (Hive infra)
    → T012–T017 (local datasource)
      → T018–T025 (popular slice — proves pattern)
        → T026–T033 (home lists)
          → T034–T040 (detail)
            → T041–T043 (UX + search exception)
              → T044–T049 (tests + docs)
```

## Parallel Markers

Tasks marked `[P]` can be drafted in parallel during spec phase only. **Implementation tasks T006+ are strictly sequential** per user workflow.
