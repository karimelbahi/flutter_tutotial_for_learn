---
description: "Task list for movie detail screen — one commit per deliverable"
---

# Tasks: Movie Detail Screen

**Input**: Design documents from `/specs/003-movie-detail/`

**Learning rule**: One **commit group** at a time → study → commit → push → next.

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Domain & Data Layer — Step 1

**Commit**: `feat(movies): add movie detail domain and data layer`

- [ ] T001 [P] Create `lib/features/movies/domain/entities/movie_detail.dart`
- [ ] T002 [P] Create `lib/features/movies/domain/entities/cast_member.dart`
- [ ] T003 [P] Create `lib/features/movies/data/models/movie_detail_model.dart`
- [ ] T004 [P] Create `lib/features/movies/data/models/movie_credits_model.dart`
- [ ] T005 Add detail/credits/similar endpoints to `lib/features/movies/data/api/tmdb_api.dart` + `build_runner`
- [ ] T006 Extend `lib/features/movies/data/datasources/movie_remote_data_source.dart`
- [ ] T007 Extend `lib/features/movies/domain/repositories/movie_repository.dart`
- [ ] T008 Implement extensions in `lib/features/movies/data/repositories/movie_repository_impl.dart`
- [ ] T009 [P] Create `lib/features/movies/domain/usecases/get_movie_detail.dart`
- [ ] T010 [P] Create `lib/features/movies/domain/usecases/get_movie_cast.dart`
- [ ] T011 [P] Create `lib/features/movies/domain/usecases/get_similar_movies.dart`

---

## Phase 2: Cubits — Step 2

**Commit**: `feat(movies): add movie detail cubits`

- [ ] T012 Create `lib/features/movies/presentation/cubit/movie_detail_state.dart`
- [ ] T013 Create `lib/features/movies/presentation/cubit/movie_detail_cubit.dart`
- [ ] T014 Create `lib/features/movies/presentation/cubit/movie_cast_state.dart`
- [ ] T015 Create `lib/features/movies/presentation/cubit/movie_cast_cubit.dart`
- [ ] T016 Create `lib/features/movies/presentation/cubit/similar_movies_state.dart`
- [ ] T017 Create `lib/features/movies/presentation/cubit/similar_movies_cubit.dart`
- [ ] T018 Add cubit factories to `lib/features/movies/presentation/movies_presentation_module.dart`

---

## Phase 3: User Story 1 — View Movie Information (P1)

**Commit 3**: `feat(movies): add movie detail screen shell and backdrop`

- [ ] T019 [US1] Create `lib/features/movies/presentation/screens/movie_detail_screen.dart` shell
- [ ] T020 [US1] Add backdrop carousel section reusing `CarouselItem`
- [ ] T021 [US1] Wire `AppRouter` to `MovieDetailScreen`; remove placeholder
- [ ] T022 [US1] Add detail loading/error UI with retry

**Commit 4**: `feat(movies): add movie detail info and overview section`

- [ ] T023 [US1] Add title, year, runtime header with popup menu stub
- [ ] T024 [US1] Add poster, genre chips, overview section

**Commit 5**: `feat(movies): add movie detail stats section`

- [ ] T025 [US1] Add rating / revenue / status stats row

---

## Phase 4: User Story 2 — Cast & Similar (P2)

**Commit 6**: `feat(movies): add movie cast section`

- [ ] T026 [US2] Add cast section with horizontal `MovieCard` list (max 15)
- [ ] T027 [US2] Cast loading/error states independent of detail

**Commit 7**: `feat(movies): add similar movies section`

- [ ] T028 [US2] Add similar movies section with `SectionHeader` + `MovieCard`
- [ ] T029 [US2] Similar tap navigates to detail with new `movieId`
- [ ] T030 [US2] Reload cubits when `movieId` changes (stale guard)

---

## Phase 5: User Story 3 — Actions & i18n (P3)

**Commit**: included in steps 3–7

- [ ] T031 [US3] Implement Visit Website via `url_launcher` in popup menu
- [ ] T032 [US3] Add detail i18n keys in `assets/translations/en.json` and `ar.json`

---

## Phase 6: Polish

**Commit**: `docs(movies): validate movie detail against quickstart checklist`

- [ ] T033 Run full quickstart validation
- [ ] T034 Run `dart analyze lib/` and `flutter test`
- [ ] T035 Create `specs/003-movie-detail/checklists/implementation-validation.md`

---

## Commit sequence

| Order | Commit message |
|-------|----------------|
| 1 | `feat(movies): add movie detail domain and data layer` |
| 2 | `feat(movies): add movie detail cubits` |
| 3 | `feat(movies): add movie detail screen shell and backdrop` |
| 4 | `feat(movies): add movie detail info and overview section` |
| 5 | `feat(movies): add movie detail stats section` |
| 6 | `feat(movies): add movie cast section` |
| 7 | `feat(movies): add similar movies section` |
| 8 | `docs(movies): validate movie detail against quickstart checklist` |
