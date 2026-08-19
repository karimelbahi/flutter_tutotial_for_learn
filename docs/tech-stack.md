# Tech Stack

Core libraries and how we use them in this project.

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.x      # Cubit state management
  equatable: ^2.x         # Value equality for states
  easy_localization: ^3.x # i18n (en, ar)
  dio: ^5.x               # HTTP client
  hive: ^2.x              # Local NoSQL storage
  hive_flutter: ^1.x      # Hive Flutter integration
  flutter_secure_storage: ^9.x  # Encrypted key-value storage
  shared_preferences: ^2.x      # Simple preferences
  flutter_dotenv: ^5.x    # .env for TMDB config (existing)
```

## State Management — `flutter_bloc` (Cubit only)

```dart
// presentation/cubit/popular_movies_cubit.dart
class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  PopularMoviesCubit(this._getPopularMovies) : super(PopularMoviesInitial());

  final GetPopularMoviesUseCase _getPopularMovies;

  Future<void> load() async {
    emit(PopularMoviesLoading());
    final result = await _getPopularMovies();
    result.fold(
      (failure) => emit(PopularMoviesFailure(failure.message)),
      (movies) => emit(PopularMoviesSuccess(movies)),
    );
  }
}
```

**Rules:**
- Cubit calls use cases, not repositories directly (when use cases exist).
- UI uses `BlocProvider`, `BlocBuilder`, `context.read<Cubit>()`.
- No `setState` for API-driven data.

## Localization — `easy_localization`

**pubspec.yaml:**
```yaml
flutter:
  assets:
    - assets/translations/
    - .env
```

**main.dart initialization:**
```dart
await EasyLocalization.ensureInitialized();
runApp(
  EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: const MovieApp(),
  ),
);
```

**MaterialApp:**
```dart
localizationsDelegates: context.localizationDelegates,
supportedLocales: context.supportedLocales,
locale: context.locale,
```

**Translation files:**
```json
// assets/translations/en.json
{ "home": { "title": "Movie DB" } }

// assets/translations/ar.json
{ "home": { "title": "أفلام" } }
```

**Widget usage:** `'home.title'.tr()`

## Networking — `dio`

Central client: `lib/core/network/dio_client.dart`

- Base URL from `AppConfig.baseUrl`
- Timeouts: connect 15s, receive 30s
- `AuthInterceptor` reads token from `SecureStorageService`
- Log interceptor in debug only

Repositories never create their own `Dio()` instances.

## Local Storage

### Hive — structured cache
- Init in `main.dart`: `await Hive.initFlutter()`
- Boxes: e.g. `movies_box`, `favorites_box`
- Access via `HiveService` in `core/storage/`

### flutter_secure_storage — sensitive data
- API tokens, refresh tokens
- Access via `SecureStorageService`

### shared_preferences — lightweight flags
- Onboarding completed, last locale, simple toggles
- Access via `PreferencesService`

## Environment Config

Keep TMDB keys in `.env` (gitignored):

```env
API_KEY=...
BASE_URL=https://api.themoviedb.org/3
IMAGE_URL=https://image.tmdb.org/t/p/w500
```

Read via `flutter_dotenv` in `AppConfig`. Never hardcode secrets in source files.

## Error Handling Pattern

```dart
// core/errors/failures.dart
abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;
}

// domain/usecases return Either<Failure, T> or Result type
// data layer throws/catches exceptions, maps to Failure in repository impl
```

Use consistent failure types: `ServerFailure`, `CacheFailure`, `NetworkFailure`.
