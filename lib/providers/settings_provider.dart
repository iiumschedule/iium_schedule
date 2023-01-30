import 'package:flutter/material.dart';

import '../services/isar_service.dart';

class SettingsProvider extends ChangeNotifier {
  final IsarService isarService = IsarService();

  ThemeMode _themeMode = ThemeMode.system;

  SettingsProvider() {
    // apply theme from storage on startup
    readThemeData();
  }

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    saveThemeData();
    notifyListeners();
  }

  // function to read the theme data from storage
  Future<void> readThemeData() async {
    _themeMode = await isarService.retrieveThemeMode();
    notifyListeners();
  }

  // function to save the theme data to storage
  Future<void> saveThemeData() async {
    await isarService.saveThemeMode(_themeMode);
  }
}
