/*
import 'dart:io';

//// UGH
/// Maybe try https://firebase.google.com/docs/test-lab/usage-quotas-pricing.
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter/widgets.dart';

import 'package:emulators_demo/main.dart' as app;

Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsApp.debugAllowBannerOverride = false;
  runApp(const app.MyApp());
}
*/

import 'dart:async';
import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';
// import 'package:integration_test/integration_test_driver.dart';

FutureOr<void> responseDataCallback(Map<String, dynamic>? response) async {
  print('Handling responseDataCallback for $response');
}

Future<void> main() async {
  print('Running app.dart');
  try {
    await integrationDriver(
      onScreenshot: (String screenshotName, List<int> screenshotBytes) async {
        final File image = await File('screenshots/$screenshotName.png')
            .create(recursive: true);
        image.writeAsBytesSync(screenshotBytes);
        return true;
      },
    );
    print('Integration test complete');
  } catch (e) {
    print('Error occurred: $e');
  }
}
