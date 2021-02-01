import 'package:flutter_driver/driver_extension.dart';
import 'package:cloudwrite/enviroments/development.dart' as dev;

void main() {
  enableFlutterDriverExtension();
  dev.main();
}