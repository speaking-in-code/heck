# emulators_demo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

How do screenshot tests in Flutter work?


Driver:
- runs on the host machine
- processes callbacks from the running app

Test process
- runs on emulator/device
- has access to IntegrationTestWidgetsFlutterBinding, which can send messages to the driver


Testing steps
- flutter drive --driver test_driver/app.dart integration_test/app_test.dart
- app.dart uses IntegrationTestDriverExtended to communicate with app under test
- IntegrationTestDriverExtended has an onScreenshot method that looks helpful, maybe

What about on the app side?
- initializes IntegrationTestWidgetFlutterbinding
- this is the API for reporting test results
- Uses IOCallbackManager

For taking a screenshot:
- calls convertFlutterSurfaceToImage
    - This registers a cleanup function to run on test completion.
- calls takeScreenshot
- calls integrationTestChannel.captureScreenshot

That code drops into
 ./src/main/java/dev/flutter/plugins/integration_test/IntegrationTestPlugin.java
… which seems to have some weird stuff about “UI Automation” mentioned???
…. There are hundreds of lines of code here, including special handling
of android vs flutter views…

holy fuck it’s starting a thread for this???
- print line debugging shows infinite loop of waiting for a flutter view to render.


ok, debugging more
- everything is fine when the screenshot itself succeeds. The test driver extended thing captures and writes the screenshot based on the response from the app.
$ cat ./screenshots/BEE.png
brian was here




The plan:
- switch to native_screenshot
- fuck around with permissions problems until they go away (ideally just ask for something special in debug mode, since it’s only for tests)
- write to testBinding.reportData by hand.




