import 'package:cloudwrite/app/dialogs/language_dialog/language_dialog_bloc.dart';
import 'package:cloudwrite/localization/language_configuration.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LanguageDialog extends StatefulWidget {
  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  LanguageDialogBloc _bloc = LanguageDialogBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LanguageConfiguration>(
      stream: _bloc.languageStream,
      builder: (BuildContext context,
          AsyncSnapshot<LanguageConfiguration> snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.active) {
          child = AlertDialog(
              title: Text(translate("choose_language")),
              content: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: LanguageConfiguration.getAvailableLanguages()
                        .map((e) => RadioListTile(
                              title: Text(e.toString()),
                              value: e,
                              groupValue: snapshot.data,
                              selected: snapshot.data?.locale == e.locale,
                              onChanged: (value) {
                                ServiceResolver.get<FluroRouter>().pop(context);
                                if (value.locale != snapshot.data.locale) {
                                  _bloc.changeLanguage(context, value);
                                }
                              },
                            ))
                        .toList(),
                  ),
                ),
              ));
        } else {
          child = CircularProgressIndicator();
        }
        return Center(child: child);
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
