import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:cloudwrite/app_widget.dart';
import 'package:cloudwrite/cloudwrite_app.dart';
import 'package:cloudwrite/enviroments/environment_type.dart';

class EnvironmentConfig {
  static EnvironmentConfig value;

  String appName;
  EnvironmentType environmentType = EnvironmentType.DEVELOPMENT;

  EnvironmentConfig() {
    value = this;
    _init();
  }

  void _init() async {
    WidgetsFlutterBinding.ensureInitialized();

    var application = CloudWriteApp();

    await application.onCreate();

    runApp(
        LocalizedApp(application.localizationDelegate, AppWidget(application)));
  }
}
