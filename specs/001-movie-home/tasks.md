---
description: "Task list for movie home screen — one commit per deliverable"
---

# Tasks: Movie Home Screen

**Input**: Design documents from `/specs/001-movie-home/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Learning rule**: Complete one **commit group** at a time → run app → study → commit → push → next.

**Tests**: Optional; manual validation via quickstart.md unless noted.

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Feature folder structure and localization scaffold

**Commit**: `chore(movies): add feature folder structure and localization scaffold`

- [ ] T001 Create `lib/features/movies/data/models/`, `datasources/`, `repositories/` directories
- [ ] T002 Create `lib/features/movies/domain/entities/`, `repositories/`, `usecases/` directories
- [ ] T003 Create `lib/features/movies/presentation/cubit/`, `screens/`, `widgets/` directories
- [ ] T004 Add `easy_localization` to `pubspec.yaml` and create `assets/translations/en.json`, `ar.json`
- [ ] T005 Wire `EasyLocalization` in `lib/main.dart` and `lib/app/app.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core network + error layer — **Step 0 in plan**

**Commit**: `chore(movies): add core Retrofit client and shared errors`

- [ ] T006 Create `lib/core/errors/exceptions.dart` with ServerException, NetworkException
- [ ] T007 Create `lib/core/errors/failures.dart` with Failure, ServerFailure, NetworkFailure (Equatable)
- [ ] T008 Create `lib/core/network/dio_factory.dart` (Dio HTTP engine) + `error_interceptor.dart`
- [ ] T008b Create `lib/features/movies/data/api/tmdb_api.dart` (Retrofit) + run `build_runner`
- [ ] T009 Initialize `DioFactory` and `TmdbApiProvider` in `lib/main.dart` after `dotenv.load()`

**Checkpoint**: `dart analyze lib/core/` passes; Retrofit `TmdbApi` ready for datasources

---

## Phase 3: Data & Domain Layer

**Purpose**: Movie model, repository, use cases — **Step 1 in plan**

**Commit**: `feat(movies): add movie domain model and repository`

- [ ] T010 [P] Create `lib/features/movies/domain/entities/movie.dart`
- [ ] T011 [P] Create `lib/features/movies/domain/entities/genre.dart` with static 18-genre list
- [ ] T012 [P] Create `lib/features/movies/data/models/movie_model.dart` with fromJson/toEntity
- [ ] T013 Create abstract `lib/features/movies/domain/repositories/movie_repository.dart`
- [ ] T014 Create `lib/features/movies/data/datasources/movie_remote_data_source.dart`
- [ ] T015 Create `lib/features/movies/data/repositories/movie_repository_impl.dart`
- [ ] T016 [P] Create use cases in `lib/features/movies/domain/usecases/` (get_popular, get_genre, get_top_rated, get_upcoming)

**Checkpoint**: Repository can fetch popular movies from TMDB (test via temporary debug call or unit test)

---

## Phase 4: Shared Widgets — **Step 2**

**Commit**: `feat(movies): port shared presentation widgets`

- [ ] T017 [P] Port `lib/features/movies/presentation/widgets/section_header.dart` from reference
- [ ] T018 [P] Port `lib/features/movies/presentation/widgets/movie_card.dart` from reference
- [ ] T019 [P] Port `lib/features/movies/presentation/widgets/carousel_item.dart` from reference
- [ ] T020 [P] Port `lib/features/movies/presentation/widgets/dot_indicator.dart` from reference
- [ ] T021 [P] Port `lib/features/movies/presentation/widgets/custom_app_bar.dart` from reference

**Checkpoint**: Widgets use AppColors, AppSpacing, AppTypography tokens

---

## Phase 5: User Story 4 — Search Entry (Priority: P4)

**Goal**: Search icon in app bar navigates to search placeholder

**Independent Test**: Tap search icon → placeholder search screen opens

**Commit**: `feat(movies): add home shell and custom app bar`

- [ ] T022 [US4] Create `lib/features/movies/presentation/screens/movie_home_screen.dart` shell with CustomAppBar
- [ ] T023 [US4] Add search placeholder screen at `lib/features/movies/presentation/screens/search_placeholder_screen.dart`
- [ ] T024 [US4] Register routes in `lib/core/constants/app_routes.dart` and wire in `lib/app/app.dart`
- [ ] T025 [US4] Remove legacy `lib/screens/movie_home/movie_home_screen.dart`

**Checkpoint**: Home shell visible; search navigates to placeholder

---

## Phase 6: User Story 1 — Popular Carousel (Priority: P1) 🎯 MVP

**Goal**: Swipeable popular movies banner with dots

**Independent Test**: Launch app → see 5 popular movies in carousel with dot indicators

**Commit**: `feat(movies): add popular movies carousel`

- [ ] T026 [US1] Create `lib/features/movies/presentation/cubit/popular_movies_state.dart`
- [ ] T027 [US1] Create `lib/features/movies/presentation/cubit/popular_movies_cubit.dart`
- [ ] T028 [US1] Add carousel section to `movie_home_screen.dart` with BlocBuilder
- [ ] T029 [US1] Register PopularMoviesCubit in `lib/app/app.dart`
- [ ] T030 [US1] Add i18n keys for loading/error in `assets/translations/en.json` and `ar.json`

**Checkpoint**: Carousel loads from TMDB; loading/error/retry states work

---

## Phase 7: User Story 2 — Genre Tabs (Priority: P2)

**Goal**: 18 genre tabs with filtered horizontal movie list

**Independent Test**: Select genre tab → movies for that genre appear

**Commit**: `feat(movies): add genre tabs and filtered list`

- [ ] T031 [US2] Create `lib/features/movies/presentation/cubit/genre_movies_state.dart`
- [ ] T032 [US2] Create `lib/features/movies/presentation/cubit/genre_movies_cubit.dart`
- [ ] T033 [US2] Add TabBar + horizontal ListView to `movie_home_screen.dart`
- [ ] T034 [US2] Register GenreMoviesCubit; load on tab change

**Checkpoint**: Genre switching works; stale tab data prevented

---

## Phase 8: User Story 3 — Top Rated & Upcoming (Priority: P3)

**Goal**: Two labeled horizontal sections below genres

**Independent Test**: Scroll home → see Top Rated and Upcoming rows with ratings

**Commit 1**: `feat(movies): add top rated horizontal section`

- [ ] T035 [US3] Create top_rated cubit + state in `presentation/cubit/`
- [ ] T036 [US3] Add Top Rated section with SectionHeader + horizontal MovieCard list

**Commit 2**: `feat(movies): add upcoming horizontal section`

- [ ] T037 [US3] Create upcoming cubit + state in `presentation/cubit/`
- [ ] T038 [US3] Add Upcoming section with SectionHeader + horizontal MovieCard list

**Checkpoint**: Full home feed order matches reference (SC-005)

---

## Phase 9: Navigation Stub — **Step 8**

**Commit**: `feat(movies): wire movie tap to detail placeholder`

- [ ] T039 Create `lib/features/movies/presentation/screens/movie_detail_placeholder_screen.dart`
- [ ] T040 Wire onTap from carousel, genre, top-rated, upcoming → detail placeholder with movieId
- [ ] T041 Register detail route in `app_routes.dart` and `app.dart`

**Checkpoint**: All movie taps show placeholder with correct ID

---

## Phase 10: Polish

**Commit**: `docs(movies): validate home screen against quickstart checklist`

- [ ] T042 Run full quickstart.md validation scenarios
- [ ] T043 Run `dart analyze lib/` and `flutter test`
- [ ] T044 Mark completed items in `specs/001-movie-home/checklists/requirements.md`

---

## Dependencies & Execution Order

```text
Phase 1 Setup → Phase 2 Foundational (blocks all) → Phase 3 Data/Domain
  → Phase 4 Widgets → Phase 5 US4 (shell) → Phase 6 US1 (carousel)
  → Phase 7 US2 (genres) → Phase 8 US3 (rows) → Phase 9 Navigation → Phase 10 Polish
```

### Commit sequence (strict)

| Order | Commit message |
|-------|----------------|
| 1 | `chore(movies): add feature folder structure and localization scaffold` |
| 2 | `chore(movies): add core Retrofit client and shared errors` |
| 3 | `feat(movies): add movie domain model and repository` |
| 4 | `feat(movies): port shared presentation widgets` |
| 5 | `feat(movies): add home shell and custom app bar` |
| 6 | `feat(movies): add popular movies carousel` |
| 7 | `feat(movies): add genre tabs and filtered list` |
| 8 | `feat(movies): add top rated horizontal section` |
| 9 | `feat(movies): add upcoming horizontal section` |
| 10 | `feat(movies): wire movie tap to detail placeholder` |

---

## MVP Scope

**Minimum demo**: Complete through Phase 6 (User Story 1 — popular carousel on home shell).

**Full home**: Complete through Phase 9.

---

## Notes

- Reference clone: `/Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit`
- Do NOT implement full search or detail screens here (specs 002/003)
- One commit per commit group above; study code between commits
