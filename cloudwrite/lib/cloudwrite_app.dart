import 'package:cloudwrite/api/client.dart';
import 'package:cloudwrite/app/pages/auth/auth_service.dart';
import 'package:cloudwrite/core/application.dart';
import 'package:cloudwrite/localization/language_manager.dart';
import 'package:cloudwrite/localization/localization_service.dart';
import 'package:cloudwrite/routing.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class CloudWriteApp extends Application {
  LocalizationDelegate localizationDelegate;

  @override
  Future onCreate() async {
    await _initStorage();
    await _initServiceLocator();
    await _initLocalization();
    _initLogger();
    _initRouter();
  }

  @override
  void onTerminate() {}

  _initStorage() {
    GetIt.instance.registerSingleton(FlutterSecureStorage());
  }

  _initServiceLocator() {
    GetIt.instance.registerSingleton<LanguageManager>(
        LocalizationService(ServiceResolver.get()));
    GetIt.instance.registerSingleton(GraphQLService());
    GetIt.instance
        .registerSingleton<AuthService>(AuthService(ServiceResolver.get()));
  }

  Future _initLocalization() async {
    var localizationService = ServiceResolver.get<LanguageManager>();

    localizationDelegate = await localizationService.initLocalization();
  }

  void _initRouter() {
    var router = FluroRouter();
    Routing.configureRoutes(router);
    GetIt.instance.registerSingleton(router);
  }

  void _initLogger() {
    GetIt.instance.registerSingleton(Logger());
  }
}
