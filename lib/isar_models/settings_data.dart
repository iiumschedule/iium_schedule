import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'settings_data.g.dart';

@collection
class SettingsData {
  Id id = 0;

  @enumerated
  ThemeMode themeSetting = ThemeMode.system;
}
