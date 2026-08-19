# Implementation Plan — Flutter TMDB Movie App

**Project**: `flutter_tutotial_for_learn`  
**Reference app**: [flutter-tmdbmovie-bloc-cubit](https://github.com/ihsaninh/flutter-tmdbmovie-bloc-cubit)  
**Local reference clone**: `/Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit`  
**Last updated**: 2026-08-20

---

## How to use this document

This is the **master roadmap** for the whole app. Each major screen also has its own SpecKit bundle under `specs/` when you are ready to implement it in detail.

| Artifact | Path | Purpose |
|----------|------|---------|
| This file | `docs/implementation-plan.md` | End-to-end flow, phases, checkpoints |
| Feature spec | `specs/001-movie-home/spec.md` | What the home screen must do |
| Feature plan | `specs/001-movie-home/plan.md` | How to build home (commit strategy) |
| Task checklist | `specs/001-movie-home/tasks.md` | Checkbox tasks for home only |
| Architecture | `docs/architecture.md` | Layer rules and data flow |

### Learning rules (from your workflow)

1. **Screen-by-screen** — finish Home before Search, Search before Detail.
2. **Section-by-section on Home** — carousel → genres → top rated → upcoming (never batch in one commit).
3. **One commit per deliverable** — implement → run app → study code → commit → push → next.
4. **Study after every commit** — trace `Screen → Cubit → UseCase → Repository → DataSource → TmdbApi`.
5. **Reference-driven UI** — port layout from the local clone; use `AppColors`, `AppSpacing`, `AppTypography`.

### Progress legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Done and committed |
| 🔄 | Coded locally, not committed yet |
| ⬜ | Not started |

---

## App overview

```text
main.dart
  → MovieApp.initialize()          # binding, locale, portrait lock
  → dotenv.load('.env')            # TMDB secrets
  → DioFactory.configure()         # shared HTTP engine
  → TmdbApiProvider.configure()    # Retrofit client
  → runApp(MovieApp)
      → MaterialApp (AppTheme.dark, easy_localization)
          → AppRouter
              → MovieHomeScreen     # Phase 7
              → SearchScreen        # Phase 8
              → MovieDetailScreen   # Phase 9
```

### Target screens (reference parity)

| Screen | Key features | Spec folder |
|--------|--------------|-------------|
| **Home** | Popular carousel, 18 genre tabs, top-rated row, upcoming row, search icon | `specs/001-movie-home/` |
| **Search** | Debounced query, result list, tap → detail | `specs/002-movie-search/` *(create when home is done)* |
| **Detail** | Backdrop carousel, poster, genres, overview, stats, cast, similar movies | `specs/003-movie-detail/` *(create when search is done)* |

---

## Phase 1: Project Bootstrap

| Task | Description | Status |
|------|-------------|--------|
| 1.1 | Git repo, `.gitignore`, GitHub remote | ✅ |
| 1.2 | Flutter project + movie app dependencies (`pubspec.yaml`) | ✅ |
| 1.3 | `.env` + `.env.example` for TMDB keys | ✅ |
| 1.4 | `AppConfig` — base URL, image URL, endpoint helpers | ✅ |

**Checkpoint**: `flutter pub get` succeeds; `.env` is gitignored.

**Commit**: `chore: add movie app dependencies and env template`

---

## Phase 2: Design System & App Shell

| Task | Description | Status |
|------|-------------|--------|
| 2.1 | Design tokens — `AppColors`, `AppSpacing`, `AppTypography` | ✅ |
| 2.2 | `AppTheme.dark` — cinematic dark theme | ✅ |
| 2.3 | `MovieApp` + `main.dart` boot sequence | ✅ |
| 2.4 | Placeholder home screen (visual proof of theme) | ✅ |

**Checkpoint**: `flutter run` shows dark **Movie DB** shell.

**Commits**:
- `feat: add design tokens and TMDB config layer`
- `feat: add app shell and home screen placeholder`

---

## Phase 3: Documentation & Spec Kit

| Task | Description | Status |
|------|-------------|--------|
| 3.1 | `docs/` — architecture, folder structure, tech stack, workflow | ✅ |
| 3.2 | Cursor skill + rules for Clean Architecture | ✅ |
| 3.3 | Spec Kit + project constitution (`.specify/`) | ✅ |
| 3.4 | Reference repo doc (`docs/reference-repo.md`) | ✅ |
| 3.5 | Home feature spec + plan + tasks (`specs/001-movie-home/`) | ✅ |

**Checkpoint**: Agent and you share the same conventions before feature work.

**Commits**: `docs: …`, `chore: add Spec Kit …`, `spec/plan/tasks: 001-movie-home`

---

## Phase 4: Core Network Layer

| Task | Description | Status |
|------|-------------|--------|
| 4.1 | `core/errors/` — exceptions + `Failure` types | ✅ |
| 4.2 | `core/network/dio_factory.dart` — timeouts, logging | ✅ |
| 4.3 | `core/network/interceptors/error_interceptor.dart` | ✅ |
| 4.4 | `features/movies/data/api/tmdb_api.dart` — Retrofit interface | ✅ |
| 4.5 | `tmdb_api_provider.dart` + `build_runner` codegen | ✅ |
| 4.6 | Wire `DioFactory` + `TmdbApiProvider` in `main.dart` | ✅ |

**Checkpoint**: `dart analyze lib/core/` passes; Retrofit client ready for datasources.

**Commit**: `chore(movies): add core Retrofit client and shared errors`

---

## Phase 5: Movies Domain & Data

| Task | Description | Status |
|------|-------------|--------|
| 5.1 | Domain entities — `Movie`, `Genre` (18 static genres) | ✅ |
| 5.2 | `MovieModel` + JSON mapping | ✅ |
| 5.3 | Abstract `MovieRepository` | ✅ |
| 5.4 | `MovieRemoteDataSource` → `TmdbApi` | ✅ |
| 5.5 | `MovieRepositoryImpl` | ✅ |
| 5.6 | Use cases — popular, genre, top-rated, upcoming | ✅ |
| 5.7 | Retrofit endpoints for home lists | ✅ |

**Checkpoint**: Repository can fetch popular movies from TMDB.

**Commit**: `feat(movies): add domain/data layer and migrate networking to Retrofit`

---

## Phase 6: Shared Presentation Widgets

| Task | Description | Status |
|------|-------------|--------|
| 6.1 | `section_header.dart` | ✅ |
| 6.2 | `movie_card.dart` | ✅ |
| 6.3 | `carousel_item.dart` | ✅ |
| 6.4 | `dot_indicator.dart` | ✅ |
| 6.5 | `custom_app_bar.dart` | ✅ |
| 6.6 | `widget_preview_support.dart` — `@Preview` wrappers | ✅ |
| 6.7 | `widget_preview_screen.dart` — debug gallery on device | ✅ |

**Reference**: `flutter-tmdbmovie-bloc-cubit/lib/widgets/`

**Checkpoint**: Widget gallery runs in debug; tokens used everywhere (no hardcoded colors).

**Commit**: `feat(movies): port shared presentation widgets`

---

## Phase 7: Home Screen (`001-movie-home`)

**Spec**: [`specs/001-movie-home/spec.md`](../specs/001-movie-home/spec.md)  
**Detailed tasks**: [`specs/001-movie-home/tasks.md`](../specs/001-movie-home/tasks.md)

| Task | Description | Status |
|------|-------------|--------|
| 7.1 | Localization scaffold — `easy_localization`, `en.json`, `ar.json` | 🔄 |
| 7.2 | `AppRoutes` + `AppRouter` — home, search, detail, dev preview | 🔄 |
| 7.3 | UI: Home shell + `CustomAppBar` + search navigation | 🔄 |
| 7.4 | UI: Search placeholder screen | 🔄 |
| 7.5 | Remove legacy `lib/screens/movie_home/` | 🔄 |
| 7.6 | Cubit: Popular movies carousel + dot indicators | ⬜ |
| 7.7 | Cubit: Genre tabs (18) + horizontal filtered list | ⬜ |
| 7.8 | Cubit: Top-rated horizontal section | ⬜ |
| 7.9 | Cubit: Upcoming horizontal section | ⬜ |
| 7.10 | Navigation: Movie tap → detail placeholder (pass `movieId`) | ⬜ |
| 7.11 | Polish: quickstart validation + `dart analyze` | ⬜ |

**Checkpoint**: User can browse the full home feed; every movie tap opens a detail placeholder with the correct ID; search icon opens search placeholder.

**Commit sequence** (strict — one per row):

| Order | Commit message |
|-------|----------------|
| 1 | `feat(movies): add home shell, routing, and localization` |
| 2 | `feat(movies): add popular movies carousel` |
| 3 | `feat(movies): add genre tabs and filtered list` |
| 4 | `feat(movies): add top rated horizontal section` |
| 5 | `feat(movies): add upcoming horizontal section` |
| 6 | `feat(movies): wire movie tap to detail placeholder` |

**Study focus per step**:

| Step | What you learn |
|------|----------------|
| 7.1–7.5 | Routing, i18n, screen scaffold |
| 7.6 | First real Cubit + `BlocBuilder` + TMDB data on screen |
| 7.7 | `TabController`, tab-change loading, stale-data guard |
| 7.8–7.9 | Parallel sections, independent loading/error states |
| 7.10 | Named routes with arguments |

---

## Phase 8: Search Screen (`002-movie-search`)

**Spec**: create with `/speckit-specify` when Phase 7 is complete.

| Task | Description | Status |
|------|-------------|--------|
| 8.1 | Spec + plan + tasks — `specs/002-movie-search/` | ⬜ |
| 8.2 | Domain: `SearchMovies` use case + repository method | ⬜ |
| 8.3 | Data: Retrofit `search/movie` endpoint + model mapping | ⬜ |
| 8.4 | Core: `Debouncer` utility (`core/utils/debouncer.dart`) | ⬜ |
| 8.5 | UI: Port `search_form_field.dart` | ⬜ |
| 8.6 | UI: Port `list_tile_search.dart` | ⬜ |
| 8.7 | Cubit: `SearchMoviesCubit` — query, loading, empty, error | ⬜ |
| 8.8 | UI: `SearchScreen` — debounced input, clear button, results | ⬜ |
| 8.9 | Navigation: result tap → `MovieDetailScreen` | ⬜ |
| 8.10 | i18n: search hints, empty state, errors (en + ar) | ⬜ |

**Reference**: `flutter-tmdbmovie-bloc-cubit/lib/screens/search.dart`

**Checkpoint**: User can type a movie name, see debounced results, and open detail from a result.

**Commit sequence**:

| Order | Commit message |
|-------|----------------|
| 1 | `feat(movies): add search domain and data layer` |
| 2 | `feat(movies): add search presentation widgets` |
| 3 | `feat(movies): add search screen with debounced cubit` |

---

## Phase 9: Movie Detail Screen (`003-movie-detail`)

**Spec**: create with `/speckit-specify` when Phase 8 is complete.

| Task | Description | Status |
|------|-------------|--------|
| 9.1 | Spec + plan + tasks — `specs/003-movie-detail/` | ⬜ |
| 9.2 | Domain: `MovieDetail`, `CastMember`, `SimilarMovie` entities | ⬜ |
| 9.3 | Data: detail / credits / similar Retrofit endpoints + models | ⬜ |
| 9.4 | Use cases: get detail, get cast, get similar | ⬜ |
| 9.5 | Cubit: `MovieDetailCubit` | ⬜ |
| 9.6 | Cubit: `MovieCastCubit` | ⬜ |
| 9.7 | Cubit: `SimilarMoviesCubit` | ⬜ |
| 9.8 | UI: Backdrop carousel (reuse `CarouselItem`) | ⬜ |
| 9.9 | UI: Title, year, runtime, popup menu (share / website) | ⬜ |
| 9.10 | UI: Poster + genre chips + overview | ⬜ |
| 9.11 | UI: Stats row — rating, status, language | ⬜ |
| 9.12 | UI: Cast horizontal list | ⬜ |
| 9.13 | UI: Similar movies row (reuse `MovieCard` + `SectionHeader`) | ⬜ |
| 9.14 | Navigation: similar movie tap → same screen, new `movieId` | ⬜ |
| 9.15 | Replace detail placeholder route with real screen | ⬜ |
| 9.16 | i18n: detail labels, menu items, section headers (en + ar) | ⬜ |

**Reference**: `flutter-tmdbmovie-bloc-cubit/lib/screens/movie_detail.dart`

**Checkpoint**: User can open any movie from home or search and see full detail with cast and similar titles.

**Commit sequence** (section-by-section, like home):

| Order | Commit message |
|-------|----------------|
| 1 | `feat(movies): add movie detail domain and data layer` |
| 2 | `feat(movies): add movie detail cubits` |
| 3 | `feat(movies): add movie detail screen shell and backdrop` |
| 4 | `feat(movies): add movie detail info and overview section` |
| 5 | `feat(movies): add movie detail stats section` |
| 6 | `feat(movies): add movie cast section` |
| 7 | `feat(movies): add similar movies section` |

---

## Phase 10: Navigation & Polish

| Task | Description | Status |
|------|-------------|--------|
| 10.1 | Remove debug `WidgetPreviewScreen` route (or gate behind dev flag) | ⬜ |
| 10.2 | Remove search + detail placeholder screens | ⬜ |
| 10.3 | Consistent back navigation across all screens | ⬜ |
| 10.4 | Full i18n audit — no hardcoded UI strings | ⬜ |
| 10.5 | Error / empty / loading states on every screen | ⬜ |
| 10.6 | `dart analyze lib/` clean | ⬜ |
| 10.7 | Widget tests for critical cubits (optional) | ⬜ |
| 10.8 | Compare UI to reference screenshots (`screenshoots/ss1–ss7.jpg`) | ⬜ |

**Checkpoint**: App matches reference app flow: Home → Search → Detail → Similar → Detail, with bilingual UI.

**Commit**: `chore(movies): polish navigation and remove dev placeholders`

---

## Phase 11: Optional Enhancements (after MVP)

Not required for reference parity; pick when core app is stable.

| Task | Description | Status |
|------|-------------|--------|
| 11.1 | Hive cache for home lists (offline-friendly) | ⬜ |
| 11.2 | Pull-to-refresh on home sections | ⬜ |
| 11.3 | Favorites / watchlist (local Hive) | ⬜ |
| 11.4 | Locale switcher in settings | ⬜ |
| 11.5 | Deep links / share movie URL | ⬜ |

---

## Current status summary

```text
Phase 1  Bootstrap              ████████████████████  100%  ✅
Phase 2  Design & shell          ████████████████████  100%  ✅
Phase 3  Docs & Spec Kit         ████████████████████  100%  ✅
Phase 4  Core network            ████████████████████  100%  ✅
Phase 5  Domain & data           ████████████████████  100%  ✅
Phase 6  Shared widgets          ████████████████████  100%  ✅
Phase 7  Home screen             ████░░░░░░░░░░░░░░░░   20%  🔄  ← YOU ARE HERE
Phase 8  Search screen           ░░░░░░░░░░░░░░░░░░░░    0%  ⬜
Phase 9  Detail screen           ░░░░░░░░░░░░░░░░░░░░    0%  ⬜
Phase 10 Polish                  ░░░░░░░░░░░░░░░░░░░░    0%  ⬜
```

### Next action

1. **Commit Phase 7.1–7.5** (localization + home shell + routing) — files are staged locally.
2. **Implement 7.6** — popular movies carousel (`PopularMoviesCubit`).
3. Continue down Phase 7 one commit at a time.

Run `/speckit-implement` or ask the agent to implement **only the next unchecked task** in `specs/001-movie-home/tasks.md`.

---

## Reference file map

| Our target | Reference source |
|------------|------------------|
| `presentation/widgets/movie_card.dart` | `lib/widgets/movie_card.dart` |
| `presentation/widgets/carousel_item.dart` | `lib/widgets/carousel_item.dart` |
| `presentation/widgets/section_header.dart` | `lib/widgets/section_header.dart` |
| `presentation/widgets/dot_indicator.dart` | `lib/widgets/dot_indicator.dart` |
| `presentation/widgets/custom_app_bar.dart` | `lib/widgets/custom_appbar.dart` |
| `presentation/widgets/search_form_field.dart` | `lib/widgets/search_form_field.dart` |
| `presentation/widgets/list_tile_search.dart` | `lib/widgets/list_tile_search.dart` |
| `presentation/screens/movie_home_screen.dart` | `lib/screens/movie_home.dart` |
| `presentation/screens/search_screen.dart` | `lib/screens/search.dart` |
| `presentation/screens/movie_detail_screen.dart` | `lib/screens/movie_detail.dart` |

---

## Study checklist (repeat after every commit)

- [ ] Trace data flow: Screen → Cubit → UseCase → Repository → DataSource → `TmdbApi`
- [ ] Confirm design tokens used (`AppColors`, `AppSpacing`, `AppTypography`)
- [ ] Compare layout to reference file in the table above
- [ ] Run app — only the new section/screen should have changed
- [ ] Check both `en.json` and `ar.json` for new strings
