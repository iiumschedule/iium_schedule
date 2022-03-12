import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class SavedScheduleProvider extends ChangeNotifier {
  final _box = Hive.box(kHiveSavedSchedule);

  /// oldName is needed to detect is schedule is renamed,
  /// if it is, the key with `oldName` will be deleted
  /// and a new schedule will be saved in the new key (`name`)
  void setSchedule(
      {required String name, required List<dynamic> data, String? oldName}) {
    if ((oldName != null) || (oldName == name)) _box.delete(oldName);
    _box.put(name, jsonEncode(data));
    notifyListeners();
  }

  Box get data => _box;
}
