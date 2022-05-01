import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:test_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('locale change test', () {
    testWidgets('check locale is fr_FR', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final localeFinder = find.byKey(const Key('locale'));
      expect(localeFinder, findsOneWidget);

      final Text text = tester.firstWidget(localeFinder);
      expect(text.data!, equalsIgnoringCase('Locale: fr_fr'));

      final Text date = tester.firstWidget(find.byKey(const Key('date')));
      expect(date.data!,
          equalsIgnoringCase('Test date 2022-05-01: dimanche 1 mai'));
    });
  });
}
