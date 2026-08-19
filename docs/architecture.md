# Architecture Overview

This project follows **Clean Architecture** with a **Feature-First** folder layout. Each feature owns its data, domain, and presentation layers. Shared infrastructure lives in `lib/core/`.

## Goals

- **Testable**: business logic is isolated from Flutter widgets and HTTP.
- **Scalable**: new features are added as self-contained modules.
- **Maintainable**: dependencies point inward; UI never talks to Dio directly.
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
│  Depends on: domain contracts + core (Dio, Hive, etc.)   │
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

## Data Flow (example: fetch popular movies)

```
MovieHomeScreen
  → context.read<PopularMoviesCubit>().load()
  → GetPopularMoviesUseCase.call()
  → MovieRepository.getPopularMovies()        [abstract, domain]
  → MovieRepositoryImpl.getPopularMovies()    [data]
  → MovieRemoteDataSource.fetchPopular()
  → DioClient.get('/movie/popular')
  → JSON → MovieModel → entity/UI model
  → Cubit emits PopularMoviesSuccess(movies)
  → BlocBuilder rebuilds carousel
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
| Structured local cache  | `hive` / `hive_flutter`  | Movie lists, favorites, offline cache        |
| Simple preferences      | `shared_preferences`     | Theme mode, locale override, onboarding flags |

## Networking

- Single `DioClient` singleton in `lib/core/network/dio_client.dart`
- Auth interceptor attaches tokens from secure storage
- Repositories use datasources; datasources use `DioClient`
- Map Dio errors to app failures in `lib/core/errors/`

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
