import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/screens/search_screen.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/widgets/search_form_field.dart';

import '../../../../helpers/app_test_helpers.dart';

void main() {
  setUpAll(initializeMovieAppForTests);

  testWidgets('Search screen shows localized hint and clear action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const SearchScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(SearchFormField), findsOneWidget);
    expect(find.text('Search movies...'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
