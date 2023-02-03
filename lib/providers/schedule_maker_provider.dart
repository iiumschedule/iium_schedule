import 'package:albiruni/albiruni.dart';
import 'package:flutter/foundation.dart';

import '../model/basic_subject_model.dart';

/// Manage states while user creating a new schedule
/// Previously handled by [ScheduleMakerData]
class ScheduleMakerProvider extends ChangeNotifier {
  Albiruni? albiruni;
  String? kulliyah;
  List<BasicSubjectModel>? _subjects;

  set subjects(List<BasicSubjectModel>? subjects) {
    _subjects = subjects;
    notifyListeners();
  }

  List<BasicSubjectModel>? get subjects => _subjects;
}
