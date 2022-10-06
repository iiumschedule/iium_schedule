import 'package:flutter/material.dart';

import '../hive_model/saved_subject.dart';

/// Careful. Takut2 dia ubah subject dalam jadual lain
class SavedSubjectsProvider extends ChangeNotifier {
  late List<SavedSubject> savedSubjects; //

  /// Change background colour of the given course code
  void modifyColour({required String courseCode, required Color newColor}) {
    savedSubjects
        .where((element) => element.code == courseCode)
        .forEach((element) {
      element.hexColor = newColor.value;
    });

    // _savedSubjects!.removeWhere((element) => element.code == courseCode);
    notifyListeners();
  }

  Color subjectColour(String courseCode) {
    return Color(savedSubjects
        .where((element) => element.code == courseCode)
        .first
        .hexColor!);
  }
}
