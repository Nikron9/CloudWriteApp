import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/steps.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/gherkin_register.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './gherkin_register_tests_report.json')
    ]
    ..stepDefinitions = [NavigateToLogin(), WaitForLoginForm()]
    ..buildFlavor = "development"
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/gherkin_register.dart"
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);
}
