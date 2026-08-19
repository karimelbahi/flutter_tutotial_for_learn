# Development Workflow

Step-by-step guide for building features in this project.

## Before You Code

1. Read [architecture.md](./architecture.md) and [folder-structure.md](./folder-structure.md).
2. Confirm the feature belongs in `lib/features/<name>/`.
3. Add translation keys to **both** `en.json` and `ar.json`.
4. Use design tokens from `lib/core/constants/` — do not hardcode colors/sizes.

## Step-by-Step: Add a Feature

### 1. Domain layer (inside out)

```
domain/repositories/movie_repository.dart     ← abstract contract
domain/usecases/get_popular_movies.dart       ← single responsibility
```

Use case template:
```dart
class GetPopularMoviesUseCase {
  const GetPopularMoviesUseCase(this._repository);
  final MovieRepository _repository;

  Future<Either<Failure, List<Movie>>> call() {
    return _repository.getPopularMovies();
  }
}
```

### 2. Data layer

```
data/models/movie_model.dart
data/datasources/movie_remote_data_source.dart
data/datasources/movie_local_data_source.dart   ← optional cache
data/repositories/movie_repository_impl.dart
```

Model maps JSON → domain entity or returns model if entity is skipped for speed.

### 3. Presentation layer

```
presentation/cubit/popular_movies_cubit.dart
presentation/cubit/popular_movies_state.dart
presentation/screens/movie_home_screen.dart
presentation/widgets/movie_card.dart
```

Wire Cubit at screen or app level:
```dart
BlocProvider(
  create: (_) => PopularMoviesCubit(sl())..load(),
  child: const MovieHomeScreen(),
)
```

### 4. Register dependencies

Provide Cubits/use cases/repos in `app.dart` or a dedicated `injection.dart` under `core/`.

### 5. Verify

```bash
dart analyze lib/
flutter test
flutter run
```

Test both locales: switch device language or use EasyLocalization locale toggle.

## Commit Convention

Use conventional commits, one logical change per commit:

| Prefix   | Use for                          |
|----------|----------------------------------|
| `feat`   | New feature or screen             |
| `fix`    | Bug fix                           |
| `refactor` | Structure change, no behavior |
| `chore`  | Dependencies, config              |
| `docs`   | README, docs/                     |
| `test`   | Tests only                        |

Examples:
```
feat(movies): add popular movies cubit and remote data source
feat(movies): wire home screen carousel with TMDB data
docs: update architecture guide for search feature
```

## Code Review Checklist (self-check before push)

- [ ] No API calls from widgets or Cubits (Cubit → UseCase → Repository)
- [ ] All user strings use `.tr()`
- [ ] Both `en.json` and `ar.json` updated
- [ ] States are Equatable with distinct class names
- [ ] No secrets in committed files
- [ ] Uses `AppColors`, `AppSpacing`, `AppTypography`
- [ ] Error/loading/empty states handled in UI
- [ ] `dart analyze` passes

## Migration from Current Code

Existing files to migrate when implementing:

| Current path                         | Target path                                              |
|--------------------------------------|----------------------------------------------------------|
| `lib/screens/movie_home/`            | `lib/features/movies/presentation/screens/`              |
| Future `lib/blocs/`                  | `lib/features/<feature>/presentation/cubit/`             |
| Future `lib/repositories/`           | `lib/features/<feature>/data/repositories/`              |
| Future `lib/models/`                 | `lib/features/<feature>/data/models/`                  |

Migrate one feature at a time; keep app runnable after each step.

## Roadmap Alignment

| Step | Task                                              |
|------|---------------------------------------------------|
| ✅   | Design tokens, app shell, docs                    |
| 🔜   | Core: DioFactory, Retrofit API, storage services, errors |
| 🔜   | easy_localization setup + translation files         |
| 🔜   | Feature: movies — popular list + home carousel      |
| 🔜   | Feature: movies — detail, search, genres          |
