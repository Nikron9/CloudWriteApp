import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

extension ScreenExtensions on BuildContext {
  double screenWidth() {
    return MediaQuery.of(this).size.width;
  }

  double screenHeight() {
    return MediaQuery.of(this).size.height;
  }

  bool isPortrait() {
    return MediaQuery.of(this).orientation == Orientation.portrait;
  }

  bool isLandscape() {
    return MediaQuery.of(this).orientation == Orientation.portrait;
  }

  bool isDarkMode() {
    return MediaQuery.of(this).platformBrightness == Brightness.dark;
  }
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
