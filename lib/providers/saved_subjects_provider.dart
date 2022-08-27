import 'package:flutter/material.dart';

import '../hive_model/saved_subject.dart';

class SavedSubjectsProvider extends ChangeNotifier {
  List<SavedSubject>? _savedSubjects;

  set savedSubjects(List<SavedSubject>? value) {
    _savedSubjects = value;
    notifyListeners();
  }

  List<SavedSubject>? get savedSubjects => _savedSubjects;

  /// Change background colour of the given course code
  void modifyColour({required String courseCode, required Color newColor}) {
    _savedSubjects!
        .where((element) => element.code == courseCode)
        .forEach((element) {
      element.hexColor = newColor.value;
    });

    // _savedSubjects!.removeWhere((element) => element.code == courseCode);
    notifyListeners();
  }

  Color subjectColour(String courseCode) {
    return Color(_savedSubjects!
        .where((element) => element.code == courseCode)
        .first
        .hexColor!);
  }
}
