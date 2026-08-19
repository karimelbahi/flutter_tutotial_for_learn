# Quickstart: Movie Home Screen (Learning Path)

**Feature**: 001-movie-home

Validate each step **before** moving to the next commit. See [plan.md](./plan.md) for commit messages.

## Prerequisites

```bash
cp .env.example .env   # add your TMDB API_KEY
flutter pub get
```

Reference clone (for visual comparison):

```
/Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit
```

---

## Step 0 — Retrofit + DioFactory

**Study**: How HTTP is centralized (DioFactory) and typed (Retrofit TmdbApi) before feature code.

**Validate**:
```bash
dart run build_runner build --delete-conflicting-outputs
dart analyze lib/core/network/ lib/features/movies/data/api/
```

---

## Step 1 — Movie repository

**Study**: data → domain flow; `MovieModel.fromJson`, repository interface.

**Validate**:
```bash
dart analyze lib/features/movies/
# Optional: unit test repository with mock datasource
```

---

## Step 2 — Shared widgets

**Study**: Compare each widget side-by-side with reference `lib/widgets/`.

**Validate**:
```bash
flutter run
# Widgets visible in a preview screen or home placeholder
```

---

## Step 3 — Home shell + app bar

**Study**: `Scaffold`, `CustomAppBar`, search icon → placeholder route.

**Validate**:
- Dark theme background `#1D1D27`
- Search icon tappable (navigates to placeholder)
- Commit + push before step 4

```bash
git add -A && git commit -m "feat(movies): add home shell and custom app bar"
git push
```

---

## Step 4 — Popular carousel

**Study**: `PopularMoviesCubit`, `BlocBuilder`, `CarouselSlider`, dot indicator.

**Validate**:
- [ ] Carousel shows up to 5 movies with backdrops
- [ ] Dots sync with slide index
- [ ] Loading spinner while fetching
- [ ] Error + retry on failure
- [ ] Tap navigates to detail placeholder with correct `movieId`

```bash
flutter run
```

---

## Step 5 — Genre tabs

**Study**: `TabController`, genre cubit, tab change triggers new API call.

**Validate**:
- [ ] 18 genre tabs scroll horizontally
- [ ] Selecting tab loads filtered movie row
- [ ] Rapid tab switch shows latest genre only

---

## Step 6 — Top rated section

**Study**: Independent cubit; section header widget; rating bar on cards.

**Validate**:
- [ ] "Top Rated" header visible
- [ ] Horizontal scroll of rated movies
- [ ] Section loads even if carousel failed

---

## Step 7 — Upcoming section

**Study**: Same pattern as top rated; subtitle shows release info.

**Validate**:
- [ ] Full home scroll: carousel → genres → top rated → upcoming
- [ ] Matches reference layout order (SC-005)

---

## Step 8 — Detail navigation stub

**Study**: Named routes, passing `movieId` as argument.

**Validate**:
- [ ] Tap any movie → placeholder detail screen showing movie ID
- [ ] Ready for spec 003-movie-detail

---

## Full home acceptance (before closing 001)

Run through [spec.md](./spec.md) acceptance scenarios P1–P4.

```bash
dart analyze lib/
flutter test
flutter run
```

---

## What comes next (separate specs & commits)

| Screen | Next spec |
|--------|-------------|
| Search | `/speckit-specify` → 002-movie-search |
| Movie Detail | `/speckit-specify` → 003-movie-detail |

Do not implement search or detail fully until their specs and plans exist.
