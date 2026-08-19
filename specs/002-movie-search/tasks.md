---
description: "Task list for movie search screen — one commit per deliverable"
---

# Tasks: Movie Search Screen

**Input**: Design documents from `/specs/002-movie-search/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Learning rule**: Complete one **commit group** at a time → run app → study → commit → push → next.

**Tests**: Optional; manual validation via quickstart.md unless noted.

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Data & Domain Layer — **Step 1 in plan**

**Purpose**: Retrofit search endpoint + repository + use case (blocks all UI work)

**Commit**: `feat(movies): add search domain and data layer`

- [x] T001 Add `searchMovies` endpoint to `lib/features/movies/data/api/tmdb_api.dart` and run `build_runner`
- [x] T002 Add `fetchSearchMovies(String query)` to `lib/features/movies/data/datasources/movie_remote_data_source.dart`
- [x] T003 Add `searchMovies(String query)` to abstract `lib/features/movies/domain/repositories/movie_repository.dart`
- [x] T004 Implement `searchMovies` in `lib/features/movies/data/repositories/movie_repository_impl.dart`
- [x] T005 Create `lib/features/movies/domain/usecases/search_movies.dart`

**Checkpoint**: `dart analyze lib/features/movies/` passes; Retrofit codegen includes `searchMovies`

---

## Phase 2: Search Widgets — **Step 2 in plan**

**Purpose**: Port reusable search UI from reference

**Commit**: `feat(movies): add search presentation widgets`

- [ ] T006 [P] Port `lib/features/movies/presentation/widgets/search_form_field.dart` from reference
- [ ] T007 [P] Port `lib/features/movies/presentation/widgets/list_tile_search.dart` from reference
- [ ] T008 [P] Add `@Preview` wrappers for both widgets in their files

**Checkpoint**: Widget previews run; tokens used (`AppColors`, `AppTypography`, `AppConfig.imageUrl`)

---

## Phase 3: User Story 1 — Find a Movie by Name (Priority: P1) 🎯 MVP

**Goal**: Debounced search field + loading + result list + tap → detail

**Independent Test**: Type a movie title → debounced results → tap opens detail placeholder

**Commit**: `feat(movies): add search screen with debounced cubit` (shared with US2/US3)

- [ ] T009 [US1] Create `lib/core/utils/debouncer.dart` from reference
- [ ] T010 [US1] Create `lib/features/movies/presentation/cubit/search_movies_state.dart`
- [ ] T011 [US1] Create `lib/features/movies/presentation/cubit/search_movies_cubit.dart` with stale-query guard
- [ ] T012 [US1] Create `lib/features/movies/presentation/screens/search_screen.dart` (search field in app bar, debounced query, result list)
- [ ] T013 [US1] Wire `AppRoutes.search` to `SearchScreen` in `lib/app/app_router.dart`
- [ ] T014 [US1] Remove `lib/features/movies/presentation/screens/search_placeholder_screen.dart`
- [ ] T015 [US1] Add i18n keys `search.hint`, `search.empty`, `search.error` in `assets/translations/en.json` and `ar.json`

**Checkpoint**: Search from home works; results load after ~1s debounce; tap navigates with correct `movieId`

---

## Phase 4: User Story 2 — Clear Search (Priority: P2)

**Goal**: Clear button resets field and cubit state

**Independent Test**: Enter text → tap clear → empty field and blank body

**Commit**: same as Phase 3 (`feat(movies): add search screen with debounced cubit`)

- [ ] T016 [US2] Add clear `IconButton` to `search_screen.dart` app bar actions
- [ ] T017 [US2] Implement `_onPressClear` — empty controller + `SearchMoviesCubit.reset()`
- [ ] T018 [US2] Ensure in-flight search does not repopulate list after clear (cubit query guard)

**Checkpoint**: One-tap clear returns to initial state (SC-004)

---

## Phase 5: User Story 3 — Empty and Failed Search (Priority: P3)

**Goal**: Distinct empty and error states

**Independent Test**: Nonsense query → empty message; simulate failure → error + retry

**Commit**: same as Phase 3

- [ ] T019 [US3] Add `SearchMoviesEmpty` state and UI in `search_screen.dart`
- [ ] T020 [US3] Add `SearchMoviesFailure` state with retry in `search_movies_cubit.dart` + screen
- [ ] T021 [US3] Add localized empty/error strings in `en.json` + `ar.json`

**Checkpoint**: Empty, error, and initial states are visually distinct (SC-006)

---

## Phase 6: Polish

**Commit**: `docs(movies): validate search screen against quickstart checklist`

- [ ] T022 Run full `specs/002-movie-search/quickstart.md` validation scenarios
- [ ] T023 Run `dart analyze lib/` and `flutter test`
- [ ] T024 Mark completed items in `specs/002-movie-search/checklists/implementation-validation.md` (create at converge)

---

## Dependencies & Execution Order

```text
Phase 1 Data/Domain (blocks all)
  → Phase 2 Widgets
  → Phase 3 US1 (screen + cubit core)
  → Phase 4 US2 (clear — same commit as US1)
  → Phase 5 US3 (empty/error — same commit as US1)
  → Phase 6 Polish
```

### Commit sequence (strict)

| Order | Commit message |
|-------|----------------|
| 1 | `feat(movies): add search domain and data layer` |
| 2 | `feat(movies): add search presentation widgets` |
| 3 | `feat(movies): add search screen with debounced cubit` |
| 4 | `docs(movies): validate search screen against quickstart checklist` |

---

## MVP Scope

**Minimum demo**: Complete through Phase 3 (User Story 1 — search with results and navigation).

**Full search**: Complete through Phase 5 before polish.

---

## Notes

- Reference clone: `/Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit`
- Reuse domain `Movie` entity — no new model
- Detail navigation uses existing `MovieDetailPlaceholderScreen` until spec 003
