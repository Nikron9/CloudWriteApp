import 'package:cloudwrite/enviroments/environment_config.dart';
import 'package:cloudwrite/enviroments/environment_type.dart';

void main() => Release();

class Release extends EnvironmentConfig {
  final String appName = "CloudWrite Production";
  EnvironmentType environmentType = EnvironmentType.PRODUCTION;
}
