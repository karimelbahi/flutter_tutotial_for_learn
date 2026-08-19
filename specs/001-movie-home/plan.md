# Implementation Plan: Movie Home Screen

**Branch**: `001-movie-home` | **Date**: 2026-08-20 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-movie-home/spec.md`

**Learning constraint (user)**: Implement **screen-by-screen** (and home **section-by-section**), **one commit per deliverable**, study each layer before moving on. Do not batch multiple screens or sections into a single commit.

## Summary

Build the TMDB movie **home screen** using Clean Architecture under
`lib/features/movies/`, matching the reference app layout at
`/Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit`.

The home feed includes: popular carousel → genre tabs + list → top-rated row →
upcoming row, with search icon navigation. Each slice is delivered, committed,
pushed, and studied before the next.

**Future screens** (separate specs, separate commit streams): Search (`002`),
Movie Detail (`003`).

## Technical Context

**Language/Version**: Dart 3.13+ / Flutter 3.47 (stable)

**Primary Dependencies**: flutter_bloc, equatable, retrofit, dio, flutter_dotenv,
carousel_slider, flutter_rating_bar, easy_localization (to add), hive (later cache)

**Storage**: TMDB remote API primary; Hive cache optional in later iteration

**Testing**: flutter_test widget tests per section; manual `flutter run` validation

**Target Platform**: iOS + Android (portrait primary)

**Project Type**: Mobile Flutter app (Clean Architecture, feature-first)

**Performance Goals**: Home carousel visible within 3s on typical mobile network (per SC-001)

**Constraints**: Cubit-only; no secrets in git; reference-driven UI tokens; en/ar i18n

**Scale/Scope**: 1 screen (home), 4 content sections, 7 shared widgets to port

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Clean Architecture | ✅ PASS | `lib/features/movies/{data,domain,presentation}` |
| II. Cubit-only | ✅ PASS | One cubit per home section |
| III. Localization | ✅ PASS | Add easy_localization + en/ar keys per slice |
| IV. Reference-driven UI | ✅ PASS | Port widgets from local reference clone |
| V. Security & Simplicity | ✅ PASS | AppConfig + DioFactory + Retrofit; minimal diff per commit |

**Post-design re-check**: ✅ No violations. Repository + use case pattern justified for testability and learning.

## Delivery Strategy — Screen-by-Screen, Commit-by-Commit

### App-wide screen order (learning path)

| Order | Screen | Spec (future) | Commit scope |
|-------|--------|---------------|--------------|
| 1 | **Home** | `001-movie-home` (this plan) | Multiple commits — one per section below |
| 2 | Search | `002-movie-search` | Single screen = dedicated commits |
| 3 | Movie Detail | `003-movie-detail` | Single screen = dedicated commits |

### Home screen — section commit sequence (THIS feature)

Each step: **implement → run app → study code → commit → push → then next**.

| Step | Commit message (suggested) | What you learn | Deliverable |
|------|--------------------------|----------------|-------------|
| **0** | `chore(movies): add core Retrofit client and shared errors` | Networking layer | `core/network/`, `core/errors/`, `features/movies/data/api/` |
| **1** | `feat(movies): add movie domain model and repository` | Data + domain layers | Model, datasource, repo, use case |
| **2** | `feat(movies): port shared presentation widgets` | Reusable UI | movie_card, section_header, etc. |
| **3** | `feat(movies): add home shell and custom app bar` | Screen scaffold | Shell + search nav placeholder |
| **4** | `feat(movies): add popular movies carousel` | Cubit + BlocBuilder | Carousel + dots + PopularMoviesCubit |
| **5** | `feat(movies): add genre tabs and filtered list` | TabController + cubit | GenreMoviesCubit + 18 tabs |
| **6** | `feat(movies): add top rated horizontal section` | Parallel data loading | TopRatedMoviesCubit + row |
| **7** | `feat(movies): add upcoming horizontal section` | Complete home feed | UpcomingMoviesCubit + row |
| **8** | `feat(movies): wire movie tap to detail placeholder` | Navigation | Route stub for detail (full screen later) |

**Rule**: Never combine steps 3–7 in one commit. User studies each layer before continuing.

### Study checklist (after each commit)

- [ ] Trace data flow: Screen → Cubit → UseCase → Repository → DataSource → API
- [ ] Identify which design tokens were used (`AppColors`, `AppSpacing`, `AppTypography`)
- [ ] Compare widget layout to reference file path (noted in each step)
- [ ] Run app and verify only the new section changed

## Project Structure

### Documentation (this feature)

```text
specs/001-movie-home/
├── plan.md              # This file
├── research.md          # Technology decisions
├── data-model.md        # Movie, Genre entities
├── quickstart.md        # Run & validate per step
├── contracts/           # TMDB API contracts
│   └── tmdb-home-api.md
├── spec.md
├── checklists/
└── tasks.md             # Generated by /speckit-tasks (next)
```

### Source Code (target layout)

```text
lib/
├── main.dart
├── app/app.dart
├── core/
│   ├── config/app_config.dart          # exists
│   ├── constants/                      # design tokens (exist)
│   ├── errors/failures.dart            # step 0
│   ├── network/dio_factory.dart        # step 0 — Dio HTTP engine
│   └── theme/app_theme.dart            # exists
└── features/movies/
    ├── data/
    │   ├── api/tmdb_api.dart           # step 0 — Retrofit interface
    │   ├── api/tmdb_api_provider.dart
    │   ├── models/movie_model.dart
    │   ├── datasources/movie_remote_data_source.dart
    │   └── repositories/movie_repository_impl.dart
    ├── domain/
    │   ├── entities/movie.dart
    │   ├── repositories/movie_repository.dart
    │   └── usecases/
    │       ├── get_popular_movies.dart
    │       ├── get_genre_movies.dart
    │       ├── get_top_rated_movies.dart
    │       └── get_upcoming_movies.dart
    └── presentation/
        ├── cubit/
        │   ├── popular_movies_cubit.dart
        │   ├── genre_movies_cubit.dart
        │   ├── top_rated_movies_cubit.dart
        │   └── upcoming_movies_cubit.dart
        ├── screens/movie_home_screen.dart
        └── widgets/
            ├── custom_app_bar.dart       # ref: lib/widgets/custom_appbar.dart
            ├── carousel_item.dart
            ├── dot_indicator.dart
            ├── movie_card.dart
            └── section_header.dart

assets/translations/
├── en.json
└── ar.json
```

**Structure Decision**: Feature-first Clean Architecture under `lib/features/movies/`.
Migrate/delete legacy `lib/screens/movie_home/` after step 3.

## Reference File Mapping

| Our file | Reference source |
|----------|------------------|
| `presentation/widgets/movie_card.dart` | `flutter-tmdbmovie-bloc-cubit/lib/widgets/movie_card.dart` |
| `presentation/widgets/carousel_item.dart` | `.../widgets/carousel_item.dart` |
| `presentation/widgets/section_header.dart` | `.../widgets/section_header.dart` |
| `presentation/widgets/dot_indicator.dart` | `.../widgets/dot_indicator.dart` |
| `presentation/widgets/custom_app_bar.dart` | `.../widgets/custom_appbar.dart` |
| `presentation/screens/movie_home_screen.dart` | `.../screens/movie_home.dart` |
| Genre list (18 items) | `.../models/genre.dart` |

## Complexity Tracking

No constitution violations requiring justification.

## Next Command

Run **`/speckit-tasks`** to generate `tasks.md` with the commit-sized task list above.

Do **not** run `/speckit-implement` until tasks are reviewed. Implement **step 0 only** first when ready.
