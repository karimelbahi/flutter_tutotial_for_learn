# flutter_tutotial_for_learn

A Flutter movie app inspired by [flutter-tmdbmovie-bloc-cubit](https://github.com/ihsaninh/flutter-tmdbmovie-bloc-cubit). Built step by step with **Clean Architecture (Feature-First)**, Cubit, Dio, easy_localization (en/ar), and TMDB API — matching the reference app's design and features.

## Documentation

| Resource | Path |
|----------|------|
| Architecture guide | [docs/architecture.md](docs/architecture.md) |
| Folder structure | [docs/folder-structure.md](docs/folder-structure.md) |
| Tech stack | [docs/tech-stack.md](docs/tech-stack.md) |
| Development workflow | [docs/development-workflow.md](docs/development-workflow.md) |
| Boilerplate templates | [docs/boilerplate-templates.md](docs/boilerplate-templates.md) |

### Cursor AI (skill + rules)

- **Skill:** `.cursor/skills/flutter-movie-app/SKILL.md` — agent workflow for this project
- **Rules:** `.cursor/rules/` — Clean Architecture conventions applied automatically

## Getting Started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install)
- A free [TMDB API key](https://www.themoviedb.org/settings/api)

### Setup

1. Clone the repository
2. Copy the env template and add your API key:

```bash
cp .env.example .env
```

3. Edit `.env`:

```env
API_KEY=your_tmdb_api_key_here
BASE_URL=https://api.themoviedb.org/3
IMAGE_URL=https://image.tmdb.org/t/p/w500
```

4. Install dependencies and run:

```bash
flutter pub get
flutter run
```

> **Note:** `.env` is gitignored. Never commit your API key.

---

## Startup Flow: From `main()` to the Home Screen

When you run the app, this is what happens:

```
main.dart
  → MovieApp.initialize()     (Flutter binding, portrait lock)
  → dotenv.load('.env')       (load TMDB API key + URLs)
  → runApp(MovieApp)
      → MaterialApp
          → theme: AppTheme.dark
          → home: MovieHomeScreen   (first screen)
```

### Step 1 — `main.dart` (entry point)

```dart
Future<void> main() async {
  await MovieApp.initialize();
  await dotenv.load(fileName: '.env');
  runApp(const MovieApp());
}
```

Three things happen before any UI appears:

1. **`MovieApp.initialize()`** — prepares Flutter (binding, portrait-only lock)
2. **`dotenv.load('.env')`** — loads your TMDB API key and URLs from the local `.env` file
3. **`runApp(const MovieApp())`** — starts the widget tree

### Step 2 — `MovieApp` (root widget)

`MaterialApp` is the app container. It sets:

- **Theme** → `AppTheme.dark` (dark background `#1D1D27`, white text, tab styles)
- **Home screen** → `MovieHomeScreen()` — the first screen the user sees

There is no router yet; `home:` points directly to the first screen.

### Step 3 — `MovieHomeScreen` (first screen)

The home screen uses **design tokens** instead of hardcoded values:

| UI element | Token used |
|------------|------------|
| Background | `AppTheme.dark` → `AppColors.primary` |
| Title "Movie DB" | `AppTypography.detailTitle` (28px, light weight) |
| Subtitle text | `AppTypography.detailOverview` (white70) |
| Poster card size | 120×180 (`AppSpacing.moviePosterWidth/Height`) |
| Card color | `AppColors.martinique` |
| Card border | `AppColors.divider` |
| Placeholder icon | `AppColors.placeholder` |

Currently this is a **placeholder** screen that shows the look and feel. Next steps will replace the center content with real movie data (carousel, lists, genre tabs).

---

## Full App Workflow

### Planned architecture

| Layer | Folder | Role |
|-------|--------|------|
| **Entry** | `lib/main.dart` | Boot app, load secrets |
| **App shell** | `lib/app/` | Theme, routing, global setup |
| **Screens** | `lib/screens/` | One folder per screen (UI only) |
| **State** | `lib/blocs/` *(next)* | Cubits manage loading/success/error |
| **Data** | `lib/repositories/` *(next)* | HTTP calls via Dio |
| **Models** | `lib/models/` *(next)* | Parse JSON from TMDB |
| **Design** | `lib/core/` | Colors, spacing, typography, theme |
| **Config** | `lib/core/config/` | API URLs using `.env` keys |

### Data flow (coming next)

```
User opens app
  → MovieHomeScreen builds
  → PopularMovieCubit.getPopularMovies()
  → PopularMovieRepository calls TMDB
  → JSON → MovieList model
  → Cubit emits LoadSuccess
  → BlocBuilder rebuilds UI with carousel + cards
```

### Planned screens

| Screen | Features |
|--------|----------|
| **Home** | Popular carousel, genre tabs, top-rated row, upcoming row |
| **Search** | Debounced movie search |
| **Detail** | Backdrop carousel, poster, genres, overview, cast, similar movies |

---

## Project Structure

```
lib/
├── main.dart                 ← starts everything
├── app/
│   └── app.dart              ← MaterialApp + theme
├── core/
│   ├── config/app_config.dart    ← TMDB URLs (uses .env)
│   ├── constants/                ← design tokens
│   └── theme/app_theme.dart      ← dark theme
└── screens/
    └── movie_home/
        └── movie_home_screen.dart  ← first screen UI
```

---

## Design Tokens

Matched to the reference TMDB movie app.

### Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#1D1D27` | Scaffold / app background |
| `martinique` | `#2D2D33` | Popup menus, cards |
| `amethystSmoke` | `#9E9EBC` | Secondary text |
| `mandy` | `#E15050` | Accent |

### Typography

- Carousel title: 18, bold, white
- Section headers: 14, w600, white70
- Movie card title: 13, bold, white
- Detail title: 28, w300, white
- Body/overview: white70, line height 1.4

### Layout

- Movie poster: **120 × 180**, radius **2**
- Carousel height: **220**
- Horizontal lists: height **250**
- Section padding: **12–16**

---

## Roadmap

| Step | Status | What we build |
|------|--------|----------------|
| 1 | Done | Project setup, dependencies, `.env` |
| 2 | Done | Design tokens + app shell + home placeholder |
| 3 | Next | API layer — models, repositories, Cubits |
| 4 | | Home screen — popular carousel + sections |
| 5 | | Movie cards + top-rated / upcoming rows |
| 6 | | Genre tabs + filtered lists |
| 7 | | Search screen with debounce |
| 8 | | Movie detail — backdrop, cast, similar movies |
| 9 | | Navigation + polish |

---

## Resources

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Flutter documentation](https://docs.flutter.dev/)
- [TMDB API docs](https://developer.themoviedb.org/docs)
