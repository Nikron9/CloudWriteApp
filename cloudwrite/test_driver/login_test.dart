import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Login test:', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    test("Home screen visible", () async {
      await driver.waitFor(find.byValueKey('home_screen_key'),
          timeout: Duration(seconds: 3));
    });

    test("Navigate to login screen", () async {
      await driver.tap(find.byValueKey("home_login_button_key"),
          timeout: Duration(seconds: 3));

      await driver.waitFor(find.byValueKey('login_screen_key'),
          timeout: Duration(seconds: 3));
    });

    test("Login", () async {
      await driver.tap(find.byValueKey('login_username_field_key'));
      await driver.enterText("gherkin");
      await driver.tap(find.byValueKey('login_password_field_key'));
      await driver.enterText("gherkinpassword");
      await driver.tap(find.byValueKey('login_button_key'));

      await driver.waitFor(find.byValueKey('notes_screen_key'),
          timeout: Duration(seconds: 5));
    });

    test("Logout", () async {
      await driver.tap(find.byValueKey('notes_logout_button_key'));

      await driver.waitFor(find.byValueKey('home_screen_key'),
          timeout: Duration(seconds: 5));
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });
  });
}
