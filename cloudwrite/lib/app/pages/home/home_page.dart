import 'package:cloudwrite/app/dialogs/language_dialog/language_dialog.dart';
import 'package:cloudwrite/extensions.dart';
import 'package:cloudwrite/localization/language_manager.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';

class HomePage extends StatelessWidget {
  final languageManager = ServiceResolver.get<LanguageManager>();
  final navigation = ServiceResolver.get<FluroRouter>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            key: Key("home_screen_key"),
            body: Center(
                child: Container(
                    width: context.screenWidth() * 0.9,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Column(
                          children: [
                            _topLogo(context),
                            _title(context),
                            _loginButton(context),
                            _register(context)
                          ],
                        ),
                        bottomSupportButtons(context),
                      ],
                    )))),
        onWillPop: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Exit"),
                  content: Text("Are you sure you want to exit?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("YES"),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                    FlatButton(
                      child: Text("NO"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
          return Future.value(true);
        });
  }

  Padding _topLogo(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: () {
          return context.screenHeight() * (context.isPortrait() ? 0.1 : 0.1);
        }()),
        child: Image.asset(
            "assets/images/cloudwrite_logo${context.isDarkMode() ? "-dark" : ""}.png",
            width: 175));
  }

  Align _title(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Padding(
            padding: EdgeInsets.only(top: () {
              return context.screenHeight() * (context.isPortrait() ? 0.05 : 0);
            }()),
            child: Text(
              "CloudWrite",
              style: Theme.of(context).textTheme.headline4,
            )));
  }

  Padding _loginButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: () {
          return context.screenHeight() * (context.isPortrait() ? 0.05 : 0.025);
        }()),
        child: Row(children: [
          Expanded(
              child: RaisedButton(
                  key: Key("home_login_button_key"),
                  onPressed: () => {navigation.navigateTo(context, "/login")},
                  color: Theme.of(context).primaryColor,
                  child: Text(translate("common_login"))))
        ]));
  }

  Align _register(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: MaterialButton(
          key: Key("home_register_button_key"),
          onPressed: () => {navigation.navigateTo(context, "/register")},
          child: Text(translate("common_registration"))),
    );
  }

  Row bottomSupportButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
            onPressed: () => {_showSingleChoiceDialog(context)},
            child: Text(translate("change_language"),
                style: TextStyle(fontSize: 10))),
        FlatButton(
            onPressed: () => {throw Exception("Test crash")},
            child: Text("CRASH"))
      ],
    );
  }

  _showSingleChoiceDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        return LanguageDialog();
      });
}
