import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/app/app.dart';

void main() {
  testWidgets('Movie app shows home placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const MovieApp());

    expect(find.text('Movie DB'), findsWidgets);
    expect(find.textContaining('Design tokens are ready'), findsOneWidget);
  });
}
