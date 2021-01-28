import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/material.dart';
import 'package:cloudwrite/localization/language_configuration.dart';
import 'package:cloudwrite/localization/language_manager.dart';

class LocalizationService extends ITranslatePreferences
    implements LanguageManager {
  static const CURRENT_LANGUAGE = "CURRENT_LANGUAGE";

  FlutterSecureStorage _storage;

  LocalizationService(FlutterSecureStorage storage) {
    _storage = storage;
  }

  Future<String> _getCurrentLanguageCode() async {
    return await _storage.read(key: CURRENT_LANGUAGE);
  }

  Future _setCurrentLanguageCode(String language) async {
    _storage.write(key: CURRENT_LANGUAGE, value: language);
  }

  @override
  Future changeLanguage(BuildContext context, LanguageConfiguration language) async {
    var languageCode = localeToString(language.locale);

    if (await _getCurrentLanguageCode() != languageCode) {
      _setCurrentLanguageCode(languageCode);
      changeLocale(context, languageCode);
    }
  }

  @override
  Future<LanguageConfiguration> getCurrentLanguage() async {
    LanguageConfiguration currentLanguage;

    var currentLanguageCode = await _getCurrentLanguageCode();

    if (currentLanguageCode ==
        localeToString(LanguageConfiguration.english.locale)) {
      currentLanguage = LanguageConfiguration.english;
    } else if (currentLanguageCode ==
        localeToString(LanguageConfiguration.polish.locale)) {
      currentLanguage = LanguageConfiguration.polish;
    } else {
      throw Exception("Language not implemented");
    }

    return currentLanguage;
  }

  Future<LocalizationDelegate> initLocalization() async {
    var locale = await _getCurrentLanguageCode();

    if (locale == null) {
      await _setCurrentLanguageCode(localeToString(localeFromString(Platform.localeName)));
    }

    locale = locale == null ? await _getCurrentLanguageCode() : locale;

    return await LocalizationDelegate.create(
        preferences: this,
        basePath: "assets/localization/",
        fallbackLocale: locale,
        supportedLocales: LanguageConfiguration.getAvailableLanguages()
            .map((e) => localeToString(e.locale))
            .toList());
  }

  @override
  Future<Locale> getPreferredLocale() async {
    return localeFromString(await _getCurrentLanguageCode());
  }

  @override
  Future savePreferredLocale(Locale locale) async {
    _setCurrentLanguageCode(localeToString(locale));
  }
}
