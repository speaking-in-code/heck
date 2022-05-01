import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:test_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('locale change test', () {
    testWidgets('check locale is es_ES', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final localeFinder = find.byKey(const Key('locale'));
      expect(localeFinder, findsOneWidget);

      final Text locale = tester.firstWidget(localeFinder);
      expect(locale.data!, equalsIgnoringCase('Locale: es_es'));

      final Text date = tester.firstWidget(find.byKey(const Key('date')));
      expect(date.data!,
          equalsIgnoringCase('Test date 2022-05-01: domingo, 1 de mayo'));
    });
  });
}
