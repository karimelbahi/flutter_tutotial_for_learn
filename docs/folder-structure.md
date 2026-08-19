# Folder Structure

Target layout for Clean Architecture (Feature-First).

## Full Tree

```
lib/
├── main.dart                          # App entry: bindings, Hive, EasyLocalization, runApp
├── app/
│   └── app.dart                       # MaterialApp, theme, localization, global BlocProviders
│
├── core/
│   ├── config/
│   │   └── app_config.dart            # Env-based config (TMDB URLs, keys via .env)
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_spacing.dart
│   │   ├── app_typography.dart
│   │   └── app_routes.dart
│   ├── errors/
│   │   ├── failures.dart              # ServerFailure, CacheFailure, etc.
│   │   └── exceptions.dart            # ServerException, CacheException
│   ├── network/
│   │   ├── dio_client.dart            # Singleton Dio wrapper
│   │   └── interceptors/
│   │       └── auth_interceptor.dart  # Attach token from secure storage
│   ├── storage/
│   │   ├── hive_service.dart          # Hive init + box helpers
│   │   ├── secure_storage_service.dart
│   │   └── preferences_service.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       ├── debouncer.dart
│       └── extensions/
│
└── features/
    ├── movies/                        # Example: TMDB movie feature
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── movie_model.dart
    │   │   ├── datasources/
    │   │   │   ├── movie_remote_data_source.dart
    │   │   │   └── movie_local_data_source.dart
    │   │   └── repositories/
    │   │       └── movie_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── movie.dart         # Optional pure entity
    │   │   ├── repositories/
    │   │   │   └── movie_repository.dart
    │   │   └── usecases/
    │   │       └── get_popular_movies.dart
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── popular_movies_cubit.dart
    │       │   └── popular_movies_state.dart
    │       ├── screens/
    │       │   ├── movie_home_screen.dart
    │       │   ├── movie_detail_screen.dart
    │       │   └── search_screen.dart
    │       └── widgets/
    │           ├── movie_card.dart
    │           └── section_header.dart
    │
    └── sample_feature/                # Template feature for new work
        ├── data/
        │   ├── models/
        │   ├── datasources/
        │   └── repositories/
        ├── domain/
        │   ├── usecases/
        │   └── repositories/
        └── presentation/
            ├── cubit/
            ├── screens/
            └── widgets/

assets/
└── translations/
    ├── en.json
    └── ar.json
```

## Naming Conventions

| Item              | Convention                          | Example                          |
|-------------------|-------------------------------------|----------------------------------|
| Feature folder    | snake_case, plural noun             | `movies`, `auth`, `settings`     |
| Cubit             | `{name}_cubit.dart`                 | `popular_movies_cubit.dart`      |
| State             | `{name}_state.dart`                 | `popular_movies_state.dart`      |
| Use case          | verb + noun                         | `get_popular_movies.dart`        |
| Repository (domain)| abstract class                     | `MovieRepository`                |
| Repository (data) | `{name}_repository_impl.dart`       | `movie_repository_impl.dart`     |
| Remote DS         | `{name}_remote_data_source.dart`    | `movie_remote_data_source.dart`  |
| Local DS          | `{name}_local_data_source.dart`     | `movie_local_data_source.dart`   |
| Model             | `{name}_model.dart`                 | `movie_model.dart`               |
| Screen            | `{name}_screen.dart`                | `movie_home_screen.dart`         |

## File Placement Rules

1. **UI strings** → `assets/translations/*.json`, not inline in widgets.
2. **API calls** → `data/datasources/` only.
3. **Business rules** → `domain/usecases/`.
4. **Widget rebuild logic** → `presentation/cubit/`.
5. **Shared colors/spacing** → `core/constants/`, never duplicated per feature.
6. **Feature-specific widgets** → `presentation/widgets/` inside that feature.

## Adding a New Feature Checklist

1. Create `lib/features/<feature_name>/` with `data/`, `domain/`, `presentation/`.
2. Define domain repository contract + use case(s).
3. Implement data sources and repository impl.
4. Create Cubit + states.
5. Build screen(s) and widgets.
6. Register dependencies in `app.dart` or a feature DI module.
7. Add translation keys to `en.json` and `ar.json`.
8. Add route in `core/constants/app_routes.dart` if navigable.
