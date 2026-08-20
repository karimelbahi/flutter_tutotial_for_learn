# Architecture Overview

This project follows **Clean Architecture** with a **Feature-First** folder layout. Each feature owns its data, domain, and presentation layers. Shared infrastructure lives in `lib/core/`.

## Goals

- **Testable**: business logic is isolated from Flutter widgets and HTTP.
- **Scalable**: new features are added as self-contained modules.
- **Maintainable**: dependencies point inward; UI never talks to HTTP APIs directly.
- **Consistent**: every feature follows the same Cubit → UseCase → Repository pattern.

## Layer Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation                          │
│  screens/, widgets/, cubit/                             │
│  Depends on: domain                                     │
└───────────────────────────┬─────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────┐
│                      Domain                              │
│  entities (optional), repositories (abstract), usecases/ │
│  Depends on: nothing in data/presentation                 │
└───────────────────────────┬─────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────┐
│                       Data                               │
│  models/, datasources/, repositories/ (impl)             │
│  Depends on: domain contracts + core (DioFactory, Hive, etc.)   │
└───────────────────────────┬─────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────┐
│                        Core                              │
│  network, storage, theme, errors, constants, utils       │
└─────────────────────────────────────────────────────────┘
```

## Dependency Rule

| Layer        | Can import from                         | Must NOT import from        |
|--------------|----------------------------------------|-----------------------------|
| Presentation | Domain, Core (theme/routes only)      | Data implementations        |
| Domain       | Core (failures/types only if shared)  | Data, Presentation          |
| Data         | Domain, Core                          | Presentation                |
| Core         | External packages only                | Features                    |

## State Management

- Use **Cubit only** (`flutter_bloc`). No event classes unless the user explicitly requests BLoC events.
- One Cubit per screen or cohesive UI flow.
- States extend `Equatable` with clear names: `Initial`, `Loading`, `Success`, `Failure`.

## Data Flow — Cache-First SSOT (spec 005)

Hive is the **Single Source of Truth** for UI-bound movie data. The UI never reads network responses directly.

```
MovieHomeScreen
  → PopularMoviesCubit.load()
  → WatchPopularMovies() / RefreshPopularMovies()     [domain use cases]
  → MovieRepository.watchPopularMovies()              [abstract, domain]
  → MovieRepositoryImpl                                 [data]
      ├─ watch: MovieLocalDataSource → Hive box.watch()
      └─ refresh: MovieRemoteDataSource → TmdbApi → save Hive
  → Cubit subscribes to watch stream → PopularMoviesSuccess(movies)
  → BlocBuilder rebuilds carousel

On refresh failure with cache: Cubit keeps Success + isStale → CacheStaleBanner
```

**Exceptions:** `SearchMoviesCubit` stays network-first (no search cache in v1).

### Legacy one-shot `get*` methods

Deprecated on `MovieRepository` — use `watch*` + `refresh*` instead. Search still uses `searchMovies()`.

## Data Flow (legacy reference — pre-SSOT)

```
MovieHomeScreen → getPopularMovies() → remote only → Cubit Success
```

## Localization

- Package: `easy_localization`
- Assets: `assets/translations/en.json`, `assets/translations/ar.json`
- Usage: `'home.title'.tr()` in widgets; never hardcode user-facing strings in presentation code.
- Supported locales: `en`, `ar`

## Storage Strategy

| Storage                 | Package                  | Use for                                      |
|-------------------------|--------------------------|----------------------------------------------|
| Secure tokens/secrets   | `flutter_secure_storage` | API tokens, refresh tokens                     |
| Structured local cache  | `hive` / `hive_flutter`  | Movie lists, detail, cast, similar (SSOT)    |
| Simple preferences      | `shared_preferences`     | Theme mode, locale override, onboarding flags |

### Hive cache (SSOT)

- Initialized in `main()` via `HiveService` (`lib/core/storage/`)
- Written by `MovieLocalDataSource` after successful TMDB fetch
- Read by Cubits through `MovieRepository.watch*()` streams
- Boxes: `movies_lists`, `movie_details`, `movie_cast`, `similar_movies`, `cache_metadata`
- See `specs/005-cache-first-ssot/` for full design

## Networking

- **Retrofit** typed API interfaces in `lib/features/<feature>/data/api/` (e.g. `TmdbApi`)
- **DioFactory** in `lib/core/network/dio_factory.dart` — configures Dio once as Retrofit's HTTP engine (timeouts, interceptors, debug logging)
- Datasources call Retrofit methods — never raw `dio.get()` or manual JSON parsing in repositories
- Map HTTP errors to app failures in `lib/core/errors/` via `ErrorInterceptor`
- Regenerate Retrofit code after API changes: `dart run build_runner build --delete-conflicting-outputs`

## Current vs Target Structure

The repo currently has early scaffolding:

```
lib/app/, lib/core/constants/, lib/core/theme/, lib/screens/movie_home/
```

When implementing features, migrate to:

```
lib/features/movies/presentation/screens/movie_home_screen.dart
```

Do not delete working code without a migration step. Move feature code into `lib/features/<feature>/` incrementally.

## Reference App

UI/UX is inspired by [flutter-tmdbmovie-bloc-cubit](https://github.com/ihsaninh/flutter-tmdbmovie-bloc-cubit). Design tokens live in `lib/core/constants/` and `lib/core/theme/`.
