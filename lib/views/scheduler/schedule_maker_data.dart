import 'package:albiruni/albiruni.dart';

import '../../model/basic_subject_model.dart';

/// To store the temporary user input from
/// the start (select kulliyyah) to the end (schedule render)
class ScheduleMakerData {
  ScheduleMakerData._();
  static Albiruni? albiruni;
  static String? kulliyah;
  static List<BasicSubjectModel>? subjects;
}
