# Quickstart: Movie Search Screen (Learning Path)

**Feature**: 002-movie-search

Validate each step **before** moving to the next commit. See [plan.md](./plan.md) for commit messages.

## Prerequisites

```bash
cp .env.example .env   # TMDB API_KEY required
flutter pub get
```

Home screen (`001-movie-home`) must be complete — search icon on home opens the search screen.

Reference clone (visual comparison):

```
/Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit
```

Compare side-by-side: `lib/screens/search.dart`, `lib/widgets/search_form_field.dart`, `lib/widgets/list_tile_search.dart`

---

## Step 1 — Search domain and data layer

**Study**: Extending Clean Architecture — new use case + repository method + Retrofit endpoint on existing `TmdbApi`.

**Implement**:

- Add `searchMovies` to `TmdbApi` + run `build_runner`
- Add `fetchSearchMovies(String query)` to `MovieRemoteDataSource`
- Add `searchMovies` to `MovieRepository` + `MovieRepositoryImpl`
- Add `SearchMovies` use case in `domain/usecases/search_movies.dart`

**Validate**:

```bash
dart run build_runner build --delete-conflicting-outputs
dart analyze lib/features/movies/data/ lib/features/movies/domain/
```

Optional: temporary debug call from a test or dev button to verify API returns results for `"Matrix"`.

**Commit**:

```bash
git add -A && git commit -m "feat(movies): add search domain and data layer"
git push
```

---

## Step 2 — Search presentation widgets

**Study**: Port reference widgets; use `AppColors`, `AppTypography`, `AppConfig.imageUrl()`; add `@Preview` wrappers.

**Implement**:

- `presentation/widgets/search_form_field.dart`
- `presentation/widgets/list_tile_search.dart`

**Validate**:

```bash
flutter widget-preview start
# Preview both widgets in gallery
dart analyze lib/features/movies/presentation/widgets/
```

- [x] Search field: autofocus, white hint text, no border (matches reference)
- [x] List tile: poster left, title + year subtitle, tap callback
- [x] Missing poster shows placeholder (not broken image)

**Commit**:

```bash
git add -A && git commit -m "feat(movies): add search presentation widgets"
git push
```

---

## Step 3 — Search screen with debounced cubit

**Study**: `SearchMoviesCubit`, `Debouncer`, `BlocBuilder`, replace placeholder route.

**Implement**:

- `core/utils/debouncer.dart`
- `presentation/cubit/search_movies_cubit.dart` + state
- `presentation/screens/search_screen.dart`
- Wire `AppRouter` → `SearchScreen`; remove `search_placeholder_screen.dart`
- i18n keys: `search.hint`, `search.empty`, `search.error` in `en.json` + `ar.json`

**Validate**:

```bash
flutter run
dart analyze lib/
```

Manual checks:

- [x] Home search icon opens real search screen (not placeholder)
- [x] Typing `"Batman"` shows debounced loading then results (~1s delay)
- [x] Rapid typing shows only latest query results (no stale flash) — cubit unit test
- [x] Clear (X) empties field and body
- [x] Nonsense query shows empty-state message
- [x] Tap result opens detail placeholder with correct movie ID
- [x] Back returns to home
- [x] Toggle Arabic locale — search strings translated

**Commit**:

```bash
git add -A && git commit -m "feat(movies): add search screen with debounced cubit"
git push
```

---

## Full search acceptance (before closing 002)

Run through [spec.md](./spec.md) acceptance scenarios P1–P3.

```bash
dart analyze lib/
flutter test
flutter run
```

Update `checklists/implementation-validation.md` when done (create at `/speckit-converge` or manually).

---

## What comes next

| Screen | Next spec |
|--------|-----------|
| Movie Detail | `/speckit-specify` → `003-movie-detail` (if not already) then `/speckit-plan` |

Replace detail placeholder when `003-movie-detail` is implemented.
