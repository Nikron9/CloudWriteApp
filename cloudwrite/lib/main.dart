import 'package:cloudwrite/enviroments/development.dart' as dev;
import 'package:cloudwrite/enviroments/production.dart' as prod;

Future<void> main() async {
  if (String.fromEnvironment("APPCENTER_ENVIRONMENT",
          defaultValue: "production") ==
      "production") {
    return prod.main();
  } else {
    return dev.main();
  }
}
