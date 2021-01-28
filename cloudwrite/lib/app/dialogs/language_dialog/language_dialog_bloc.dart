import 'package:flutter/cupertino.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:cloudwrite/localization/language_configuration.dart';
import 'package:cloudwrite/localization/language_manager.dart';
import 'package:rxdart/rxdart.dart';

class LanguageDialogBloc {
  var languageManager = ServiceResolver.get<LanguageManager>();

  BehaviorSubject<LanguageConfiguration> languageStream =
      BehaviorSubject<LanguageConfiguration>();

  LanguageDialogBloc() {
    languageStream
        .addStream(Stream.fromFuture(languageManager.getCurrentLanguage()));
  }

  void changeLanguage(
      BuildContext context, LanguageConfiguration selectedLanguage) {
    languageManager.changeLanguage(context, selectedLanguage);
    languageStream.sink.add(selectedLanguage);
  }

  void dispose() {
    languageStream.close();
  }
}
