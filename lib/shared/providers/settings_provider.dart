import 'package:flutter/material.dart';

import '../services/isar_service.dart';

class SettingsProvider extends ChangeNotifier {
  final IsarService isarService = IsarService();

  ThemeMode _themeMode = ThemeMode.system;
  bool _highlightLaneCurrentDay = true;
  bool _developerMode = false;
  bool _use24HourFormat = true;

  SettingsProvider() {
    // apply setting from storage on startup
    readSetings();
  }

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    isarService.saveThemeMode(_themeMode);
    notifyListeners();
  }

  // read settings on initialization
  Future<void> readSetings() async {
    _themeMode = await isarService.retrieveThemeMode();
    _developerMode = await isarService.getDeveloperModeStatus();
    _highlightLaneCurrentDay =
        await isarService.getHighlightCurrentDaySetting();
    _use24HourFormat = await isarService.getUse24HourFormatSetting();
    notifyListeners();
  }

  bool get highlightLaneCurrentDay => _highlightLaneCurrentDay;

  void setHghlightLaneCurrentDay(bool newValue) {
    _highlightLaneCurrentDay = newValue;
    isarService.saveHighlightCurrentDaySetting(_highlightLaneCurrentDay);
    notifyListeners();
  }

  bool get developerMode => _developerMode;

  void setDeveloperMode(bool developerMode) {
    _developerMode = developerMode;
    isarService.saveDeveloperModeStatus(_developerMode);
    notifyListeners();
  }

  bool get use24HourFormat => _use24HourFormat;

  void setUse24HourFormat(bool newValue) {
    _use24HourFormat = newValue;
    isarService.saveUse24HourFormatSetting(_use24HourFormat);
    notifyListeners();
  }
}
