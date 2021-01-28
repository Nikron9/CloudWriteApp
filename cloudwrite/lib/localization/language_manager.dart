import 'package:flutter/widgets.dart';
import 'package:cloudwrite/localization/language_configuration.dart';

abstract class LanguageManager {
  initLocalization();
  changeLanguage(BuildContext context, LanguageConfiguration language);
  getCurrentLanguage();
}
