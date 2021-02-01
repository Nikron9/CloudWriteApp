import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric NavigateToLogin() {
  return when1<String, FlutterWorld>(
    'When I press the {string} button',
    (key, context) async {
      return await FlutterDriverUtils.tap(
          context.world.driver, find.byValueKey(key));
    },
  );
}

StepDefinitionGeneric WaitForLoginForm() {
  return then1<String, FlutterWorld>(
    'Then I should see the {string} page',
    (key, context) async {
      return await FlutterDriverUtils.isPresent(
          context.world.driver, find.byValueKey(key));
    },
  );
}
