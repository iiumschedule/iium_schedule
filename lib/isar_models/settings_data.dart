import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

part 'settings_data.g.dart';

@collection
class SettingsData {
  Id id = 0;

  @enumerated
  ThemeMode themeSetting = ThemeMode.system;

  /// Developer mode on/off
  bool developerMode = false;

  /// Setting to turn on background highlight if current lane is the current day
  bool highlightCurrentDay = true;
}
