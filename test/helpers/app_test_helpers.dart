import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_tutotial_for_learn/app/app.dart';
import 'package:flutter_tutotial_for_learn/core/network/dio_factory.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/api/tmdb_api_provider.dart';

/// Shared test boot sequence matching [main.dart].
Future<void> initializeMovieAppForTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await MovieApp.initialize();
  await dotenv.load(fileName: '.env');
  DioFactory.instance.configure();
  TmdbApiProvider.instance.configure();
}

/// Pumps [MovieApp] with localization for widget tests.
Future<void> pumpMovieAppShell(WidgetTester tester) async {
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MovieApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}
