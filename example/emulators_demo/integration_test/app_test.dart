import 'dart:io';

import 'package:flutter/src/widgets/binding.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/_callback_io.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_screenshot/native_screenshot.dart';

import 'package:emulators_demo/main.dart' as app;

void main() {
  final testBinding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the counter starts at 0.
      expect(find.text('0'), findsOneWidget);

      // Finds the floating action button to tap on.
      final Finder fab = find.byTooltip('Increment');

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      expect(find.text('1'), findsOneWidget);

      String? path = await NativeScreenshot.takeScreenshot();
      print('Faking a screenshot, path is $path');
      final Map<String, dynamic> data = {
        'screenshotName': 'BEE',
        'bytes': File(path!).readAsBytesSync(),
      };
      assert(data.containsKey('bytes'));
      testBinding.reportData ??= <String, dynamic>{};
      testBinding.reportData!['screenshots'] ??= <dynamic>[];
      (testBinding.reportData!['screenshots']! as List<dynamic>).add(data);

      /*

      testBinding.takeScreenshot("BEE");
      print('Converting surface to image');
      await testBinding.convertFlutterSurfaceToImage();
      print('Taking screenshot');
      await testBinding.takeScreenshot('BEE');
      print('Test complete');

        */
    });
  });
}
