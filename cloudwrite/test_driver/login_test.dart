import 'package:flutter_driver/flutter_driver.dart';
import 'package:ozzie/ozzie.dart';
import 'package:test/test.dart';

void main() {
  group('LoginTest', () {
    FlutterDriver driver;
    // Ozzie ozzie;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
      // ozzie = Ozzie.initWith(driver, groupName: 'LoginTest');
    });

    test("Home screen visible", () async {
      await driver.waitFor(find.byValueKey('home_screen_key'),
          timeout: Duration(seconds: 3));

      // await ozzie.takeScreenshot('Home_screen_visible');
    });

    test("Navigate to login screen", () async {
      // await ozzie.profilePerformance("NavHomeToLogin", () async {
        await driver.tap(find.byValueKey("home_login_button_key"),
            timeout: Duration(seconds: 3));

        await driver.waitFor(find.byValueKey('login_screen_key'),
            timeout: Duration(seconds: 3));
      // });

      // await ozzie.takeScreenshot('Login_screen_visible');
    });

    test("Login", () async {
      // await ozzie.profilePerformance("LoginProcess", () async {
        await driver.tap(find.byValueKey('login_username_field_key'));
        await driver.enterText("gherkin");
        await driver.tap(find.byValueKey('login_password_field_key'));
        await driver.enterText("gherkinpassword");
        await driver.tap(find.byValueKey('login_button_key'));

        await driver.waitFor(find.byValueKey('notes_screen_key'),
            timeout: Duration(seconds: 5));
      // });

      // await ozzie.takeScreenshot('Notes_screen_visible');
    });

    test("Logout", () async {
      // await ozzie.profilePerformance("LogoutProcess", () async {
        await driver.tap(find.byValueKey('notes_logout_button_key'));

        await driver.waitFor(find.byValueKey('home_screen_key'),
            timeout: Duration(seconds: 5));
      // });

      // await ozzie.takeScreenshot('Home_screen_visible');
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
      // await ozzie.generateHtmlReport();
    });
  });
}
