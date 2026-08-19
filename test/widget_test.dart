import 'package:flutter_test/flutter_test.dart';

import 'helpers/app_test_helpers.dart';

void main() {
  setUpAll(initializeMovieAppForTests);

  testWidgets('Movie app shows home screen shell', (WidgetTester tester) async {
    await pumpMovieAppShell(tester);

    expect(find.text('Movie DB'), findsOneWidget);
    expect(find.text('TOP RATED'), findsOneWidget);
    expect(find.text('UPCOMING'), findsOneWidget);
  });
}
