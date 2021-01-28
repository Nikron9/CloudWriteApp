import 'dart:ui';

import 'package:flutter_translate/flutter_translate.dart';

abstract class LanguageConfiguration {
  LanguageConfiguration._();

  String languageCode;
  String countryCode;

  Locale get locale => localeFromString("${languageCode}_$countryCode");

  static List<LanguageConfiguration> getAvailableLanguages() {
    return [english, polish];
  }

  static English english = English();

  static Polish polish = Polish();
}

class English extends LanguageConfiguration {
  English() : super._();

  @override
  String languageCode = "en";

  @override
  String countryCode = "US";

  @override
  String toString() {
    return translate("language_english");
  }
}

class Polish extends LanguageConfiguration {
  Polish() : super._();

  @override
  String languageCode = "pl";

  @override
  String countryCode = "PL";

  @override
  String toString() {
    return translate("language_polish");
  }
}
