# Quickstart: Movie Detail Screen (Learning Path)

**Feature**: 003-movie-detail

Validate each step before the next commit. See [plan.md](./plan.md).

## Prerequisites

```bash
cp .env.example .env
flutter pub get
```

Home + Search (`001`, `002`) complete — movie taps currently open placeholder until step 3.

Reference: `/Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit/lib/screens/movie_detail.dart`

---

## Step 1 — Domain and data layer

**Study**: New entities, Retrofit endpoints, repository extension.

**Validate**:

```bash
dart run build_runner build --delete-conflicting-outputs
dart analyze lib/features/movies/data/ lib/features/movies/domain/
```

**Commit**: `feat(movies): add movie detail domain and data layer`

---

## Step 2 — Detail cubits

**Study**: Three cubits, stale `movieId` guard on detail/similar.

**Validate**: `dart analyze lib/features/movies/presentation/cubit/`

**Commit**: `feat(movies): add movie detail cubits`

---

## Step 3 — Shell + backdrop carousel

**Validate**:
- [ ] Tap movie from home → real detail screen (not placeholder)
- [ ] Backdrop carousel autoplays
- [ ] Loading spinner while detail fetches

**Commit**: `feat(movies): add movie detail screen shell and backdrop`

---

## Step 4 — Info + overview

**Validate**:
- [ ] Title, year, runtime visible
- [ ] Poster + genre chips + overview

**Commit**: `feat(movies): add movie detail info and overview section`

---

## Step 5 — Stats section

**Validate**:
- [ ] Rating / revenue / status row matches reference

**Commit**: `feat(movies): add movie detail stats section`

---

## Step 6 — Cast section

**Validate**:
- [ ] Horizontal cast list with name + character

**Commit**: `feat(movies): add movie cast section`

---

## Step 7 — Similar movies

**Validate**:
- [ ] Similar row with ratings
- [ ] Tap similar → new detail with correct ID

**Commit**: `feat(movies): add similar movies section`

---

## Full acceptance

```bash
dart analyze lib/
flutter test
flutter run
```

Update `checklists/implementation-validation.md` when done.
