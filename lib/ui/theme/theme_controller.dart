import 'package:flutter/material.dart';

part 'theme_config.dart';

class ThemeController {
  ThemeController() {
    // TODO: get instance of local DB
  }

  ThemeData getTheme() {
    return _AppThemeConfig.getThemeData(
      getThemeName(),
    );
  }

  changeTheme() {
    AppTheme currentAppTheme = getThemeName();
    switch (currentAppTheme) {
      case AppTheme.light:
        _setTheme(AppTheme.dark);
        break;
      case AppTheme.dark:
        _setTheme(AppTheme.light);
        break;
      default:
    }
  }

  AppTheme getThemeName() {
    // TODO: get theme from local DB
    return AppTheme.light;
  }

  _setTheme(AppTheme appTheme) async {
    // TODO: save theme in local DB and notify
  }
}
