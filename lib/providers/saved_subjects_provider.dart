import 'dart:math';

import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';

import '../hive_model/saved_subject.dart';

/// Careful. Takut2 dia ubah subject dalam jadual lain
class SavedSubjectsProvider extends ChangeNotifier {
  late List<SavedSubject> savedSubjects;

  void addSubject(Subject subject) {
    // generate random color
    int colour = 0xFF000000 | (Random().nextInt(0xFFFFFF));

    SavedSubject savedSubject = SavedSubject.fromSubject(
        subject: subject, subjectName: subject.title, hexColor: colour);

    savedSubjects.add(savedSubject);
    notifyListeners();
  }

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

  /// Change subject venuw
  void setVenue({required SavedSubject courseCode, required String newVenue}) {
    // savedSubjects
    //   .where((element) => element.code == courseCode)
    //   .forEach((element) {
    // element.hexColor = newColor.value;
    // });
    savedSubjects
        .where((element) => element.code == courseCode.code)
        .first
        .venue = newVenue;

    notifyListeners();
  }

  String? getVenue(String courseCode) {
    return savedSubjects
        .where((element) => element.code == courseCode)
        .first
        .venue;
  }

  /// Delete a single entity of the subject
  ///
  /// Note: This doesn't actually delete the subject from the list
  /// it just delete its DayTime of it will not be render on the screen
  void deleteSingle(SavedSubject subject) {
    // find the subject in the list
    var subjectIntance =
        savedSubjects.firstWhere((element) => element.code == subject.code);

    // if the daytime only one, it is safe to remove the subject altogether
    // since making the dayTime list empty will not not render anything
    // on screen either
    // eg: if (subject.dayTime.length == 1) savedSubjects.remove(subjectIntance);
    // BUT: It causes [Consumer] for a brief moment by the dialog as it try to read
    // from non exists property.
    // So instead, we do it like so:
    // find the target daytime and remove it from the subject property
    subjectIntance.dayTime
        .removeWhere((element) => element == subject.dayTime.first);

    // Side effect: Subject can be completely gone in the view, but the subject count is
    // still not affected. So this, we have the [cleanUpResidue] method to delete subject
    // that have no DayTime in it.

    notifyListeners();
  }

  void cleanUpResidue() {
    savedSubjects.removeWhere((element) => element.dayTime.isEmpty);
    notifyListeners();
  }
}
