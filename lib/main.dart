import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'core/network/dio_factory.dart';
import 'core/storage/hive_service.dart';
import 'features/movies/data/api/tmdb_api_provider.dart';

Future<void> main() async {
  // 1. Flutter engine + portrait lock + localization
  await MovieApp.initialize();

  // 2. Load TMDB API key from .env (gitignored)
  await dotenv.load(fileName: '.env');

  // 3. Local cache (SSOT) — must run before any repository reads/writes Hive
  await HiveService.instance.init();

  // 4. Configure HTTP + Retrofit (Step 0)
  DioFactory.instance.configure();
  TmdbApiProvider.instance.configure();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MovieApp(),
    ),
  );
}
