import 'package:cloudwrite/enviroments/environment_config.dart';
import 'package:cloudwrite/enviroments/environment_type.dart';

void main() => Development();

class Development extends EnvironmentConfig {
  final String appName = "CloudWrite Dev";
  EnvironmentType environmentType = EnvironmentType.DEVELOPMENT;
}
