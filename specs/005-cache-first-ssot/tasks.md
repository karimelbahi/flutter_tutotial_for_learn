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

- [ ] T001 Update `.specify/memory/constitution.md` — add Principle VI Cache-First SSOT (v1.2.0)
- [ ] T002 [P] Finalize `specs/005-cache-first-ssot/spec.md`
- [ ] T003 [P] Finalize `specs/005-cache-first-ssot/plan.md`
- [ ] T004 [P] Finalize `specs/005-cache-first-ssot/tasks.md`, `research.md`, `data-model.md`, `quickstart.md`
- [ ] T005 **STOP — await user approval before T006**

---

## Phase 1: Core Hive Infrastructure

**Commit**: `feat(cache-ssot): add hive dependencies and HiveService`

- [ ] T006 Add `hive` + `hive_flutter` to `pubspec.yaml`; run `flutter pub get`
- [ ] T007 Create `lib/core/storage/cache_config.dart` — TTL constants per cache key type
- [ ] T008 Create `lib/core/storage/cache_metadata.dart` — `CacheMetadata` model + `isExpired(ttl)` helper
- [ ] T009 Create `lib/core/storage/hive_service.dart` — init, open boxes (`movies_lists`, `movie_details`, `movie_cast`, `similar_movies`, `cache_metadata`)
- [ ] T010 Wire `HiveService.init()` in `lib/main.dart` before `runApp`
- [ ] T011 Validate: `dart analyze lib/core/storage/`

---

## Phase 2: Local Data Layer

**Commit**: `feat(cache-ssot): add MovieLocalDataSource with watch streams`

- [ ] T012 Add `toJson()` on `MovieModel`, `MovieDetailModel`, cast models (mirror `fromJson`)
- [ ] T013 Create `lib/features/movies/data/datasources/movie_local_data_source.dart` — abstract + impl
- [ ] T014 Implement list cache: save/get/watch for `popular`, `top_rated`, `upcoming`, `genre_{id}`
- [ ] T015 Implement detail cache: save/get/watch for detail, cast, similar by `movieId`
- [ ] T016 Implement metadata read/write per cache key; clear-on-corruption helper
- [ ] T017 Validate: unit tests for local datasource save + watch emit

---

## Phase 3: Repository Contract & Popular Movies Vertical Slice (P1)

**Commit**: `feat(cache-ssot): extend MovieRepository with watch and refresh APIs`

- [ ] T018 Extend `lib/features/movies/domain/repositories/movie_repository.dart` — watch* + refresh* methods
- [ ] T019 Refactor `movie_repository_impl.dart` — inject local + remote datasources; implement popular watch/refresh
- [ ] T020 Create `watch_popular_movies.dart` + `refresh_popular_movies.dart` use cases
- [ ] T021 Update `movies_presentation_module.dart` / DI wiring for new use cases + local datasource

**Commit**: `feat(cache-ssot): migrate PopularMoviesCubit to cache-first streams`

- [ ] T022 Extend `PopularMoviesState` — optional `isStale`, `isRefreshing`
- [ ] T023 Refactor `PopularMoviesCubit` — subscribe watch stream, background refresh, cancel on close
- [ ] T024 Update `PopularMoviesCubit` tests — cache-first: no loading flash when cache exists
- [ ] T025 Manual quickstart: home carousel instant on second launch

---

## Phase 4: Remaining Home Lists (P1)

**Commit**: `feat(cache-ssot): cache-first top rated and upcoming movies`

- [ ] T026 Add watch/refresh use cases for top rated + upcoming
- [ ] T027 Implement repository watch/refresh for top rated + upcoming
- [ ] T028 Refactor `TopRatedMoviesCubit` + `UpcomingMoviesCubit` to stream pattern
- [ ] T029 Update cubit tests for top rated + upcoming

**Commit**: `feat(cache-ssot): cache-first genre movies by genre id`

- [ ] T030 Add watch/refresh use cases for genre movies (parameterized by `genreId`)
- [ ] T031 Implement repository watch/refresh for `genre_{id}`
- [ ] T032 Refactor `GenreMoviesCubit` — resubscribe on genre tab change; cancel old subscription
- [ ] T033 Update genre cubit tests

---

## Phase 5: Movie Detail Sections (P2)

**Commit**: `feat(cache-ssot): cache-first movie detail`

- [ ] T034 Add watch/refresh use cases for movie detail
- [ ] T035 Implement repository watch/refresh for detail
- [ ] T036 Refactor `MovieDetailCubit` — stream + refresh; reload on `movieId` change

**Commit**: `feat(cache-ssot): cache-first cast and similar movies`

- [ ] T037 Add watch/refresh use cases for cast + similar
- [ ] T038 Implement repository watch/refresh for cast + similar
- [ ] T039 Refactor `MovieCastCubit` + `SimilarMoviesCubit`
- [ ] T040 Update detail-related cubit tests

---

## Phase 6: UX Polish & Search Exception (P3)

**Commit**: `feat(cache-ssot): add stale offline indicator and i18n keys`

- [ ] T041 Add `cache.stale` / `cache.offline` keys to `en.json` + `ar.json`
- [ ] T042 Add non-blocking stale banner/chip on home + detail when `isStale == true`
- [ ] T043 Document search as network-first exception in repository + spec cross-ref; verify `SearchMoviesCubit` unchanged

---

## Phase 7: Cleanup, Tests & Documentation

**Commit**: `feat(cache-ssot): add repository integration tests`

- [ ] T044 Add `movie_repository_impl` tests: cache hit, cache miss, offline-with-cache, refresh writes Hive
- [ ] T045 Remove deprecated one-shot `getPopularMovies` / etc. from repository if all cubits migrated (or mark `@Deprecated` with removal note)

**Commit**: `feat(cache-ssot): update architecture docs and validation checklist`

- [ ] T046 Update `docs/architecture.md` — SSOT data-flow diagram + Hive section
- [ ] T047 Run `dart analyze lib/` + `flutter test` — all green
- [ ] T048 Create `specs/005-cache-first-ssot/checklists/implementation-validation.md`
- [ ] T049 Run quickstart manual validation (online → offline → online)

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
