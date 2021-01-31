import 'package:cloudwrite/app/pages/auth/bloc/auth_bloc.dart';
import 'package:cloudwrite/app/pages/auth/bloc/auth_event.dart';
import 'package:cloudwrite/app/pages/auth/bloc/auth_state.dart';
import 'package:cloudwrite/app/pages/home/home_page.dart';
import 'package:cloudwrite/app/pages/notes/notes_page.dart';
import 'package:cloudwrite/app_themes.dart';
import 'package:cloudwrite/cloudwrite_app.dart';
import 'package:cloudwrite/enviroments/environment_config.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';

import 'extensions.dart';

class AppWidget extends StatefulWidget {
  final CloudWriteApp _app;

  AppWidget(this._app);

  @override
  _AppWidgetState createState() => _AppWidgetState(_app);
}

class _AppWidgetState extends State<AppWidget> {
  final CloudWriteApp _app;

  _AppWidgetState(this._app);

  var logger = ServiceResolver.get<Logger>();
  var navigation = ServiceResolver.get<FluroRouter>();

  @override
  void dispose() async {
    logger.d('dispose');
    super.dispose();
    _app.onTerminate();
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = _app.localizationDelegate;

    return BlocProvider(
        create: (context) => AuthenticationBloc()..add(AppLoaded()),
        child: LocalizationProvider(
            state: LocalizationProvider.of(context).state,
            child: MaterialApp(
              title: EnvironmentConfig.value.appName,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                localizationDelegate
              ],
              home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationAuthenticated) {
                    //home
                    return NotesPage();
                  }
                  if (state is AuthenticationInitial) {
                    //splash
                    return Container();
                  }
                  //login
                  return HomePage();
                },
              ),
              builder: (context, child) {
                return Scaffold(
                  // Global GestureDetector that will dismiss the keyboard
                  body: GestureDetector(
                    onTap: () {
                      hideKeyboard(context);
                    },
                    child: child,
                  ),
                );
              },
              supportedLocales: localizationDelegate.supportedLocales,
              locale: localizationDelegate.currentLocale,
              theme: lightTheme,
              darkTheme: darkTheme,
              onGenerateRoute: navigation.generator,
            )));
  }
}
