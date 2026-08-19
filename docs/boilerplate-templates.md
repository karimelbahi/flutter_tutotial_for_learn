# Boilerplate Templates

Copy-adapt these when implementing Clean Architecture layers. Replace `Sample` / `sample` with your feature name.

## Translation Files

**assets/translations/en.json**
```json
{
  "app": {
    "title": "Movie DB"
  },
  "home": {
    "title": "Movie DB",
    "popular": "Popular",
    "top_rated": "Top Rated",
    "upcoming": "Upcoming",
    "loading": "Loading movies...",
    "error": "Something went wrong"
  },
  "search": {
    "hint": "Search movies",
    "empty": "No results found"
  },
  "common": {
    "retry": "Retry"
  }
}
```

**assets/translations/ar.json**
```json
{
  "app": {
    "title": "أفلام"
  },
  "home": {
    "title": "أفلام",
    "popular": "الأكثر شعبية",
    "top_rated": "الأعلى تقييماً",
    "upcoming": "قريباً",
    "loading": "جاري تحميل الأفلام...",
    "error": "حدث خطأ ما"
  },
  "search": {
    "hint": "ابحث عن فيلم",
    "empty": "لا توجد نتائج"
  },
  "common": {
    "retry": "إعادة المحاولة"
  }
}
```

## main.dart

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await dotenv.load(fileName: '.env');
  await MovieApp.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MovieApp(),
    ),
  );
}
```

## app.dart (localization + theme)

```dart
MaterialApp(
  title: 'app.title'.tr(),
  debugShowCheckedModeBanner: false,
  theme: AppTheme.dark,
  localizationsDelegates: context.localizationDelegates,
  supportedLocales: context.supportedLocales,
  locale: context.locale,
  home: const MovieHomeScreen(),
)
```

## DioClient — core/network/dio_client.dart

```dart
import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  DioClient._(this._dio);

  static final DioClient instance = DioClient._(Dio());

  final Dio _dio;

  Dio get dio => _dio;

  void configure({required AuthInterceptor authInterceptor}) {
    _dio
      ..options = BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      )
      ..interceptors.addAll([
        authInterceptor,
        LogInterceptor(requestBody: true, responseBody: true),
      ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }
}
```

## Auth Interceptor — core/network/interceptors/auth_interceptor.dart

```dart
import 'package:dio/dio.dart';

import '../../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

## Cubit + State

```dart
// popular_movies_state.dart
abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();
  @override
  List<Object?> get props => [];
}

class PopularMoviesInitial extends PopularMoviesState {}
class PopularMoviesLoading extends PopularMoviesState {}
class PopularMoviesSuccess extends PopularMoviesState {
  const PopularMoviesSuccess(this.movies);
  final List<Movie> movies;
  @override
  List<Object?> get props => [movies];
}
class PopularMoviesFailure extends PopularMoviesState {
  const PopularMoviesFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
```

## Domain Repository

```dart
abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies();
}
```

## Remote Data Source

```dart
abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> fetchPopularMovies();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  MovieRemoteDataSourceImpl(this._client);
  final DioClient _client;

  @override
  Future<List<MovieModel>> fetchPopularMovies() async {
    final response = await _client.get(
      '/movie/popular',
      queryParameters: {'api_key': AppConfig.apiKey},
    );
    final results = response.data['results'] as List<dynamic>;
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }
}
```

## Screen with BlocBuilder

```dart
class MovieHomeScreen extends StatelessWidget {
  const MovieHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home.title'.tr())),
      body: BlocBuilder<PopularMoviesCubit, PopularMoviesState>(
        builder: (context, state) {
          if (state is PopularMoviesLoading) {
            return Center(child: Text('home.loading'.tr()));
          }
          if (state is PopularMoviesFailure) {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<PopularMoviesCubit>().load(),
                child: Text('common.retry'.tr()),
              ),
            );
          }
          if (state is PopularMoviesSuccess) {
            return /* build carousel/list */;
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

## Target pubspec.yaml snippet

```yaml
dependencies:
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  easy_localization: ^3.0.7
  dio: ^5.9.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.2.4
  shared_preferences: ^2.5.3
  flutter_dotenv: ^5.2.1

flutter:
  assets:
    - assets/translations/
    - .env
```
