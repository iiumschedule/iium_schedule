import 'package:isar/isar.dart';

import '../enums/subject_title_setting_enum.dart';
import 'saved_subject.dart';

part 'saved_schedule.g.dart';

@collection
class SavedSchedule {
  Id? id;

  /// Schedule title
  String? title;

  final subjects = IsarLinks<SavedSubject>();

  /// when the schedule is last modified
  DateTime lastModified;

  DateTime dateCreated;

  double fontSize;

  double heightFactor;

  @enumerated // same as EnumType.ordinal
  SubjectTitleSetting subjectTitleSetting;

  String session;

  byte semester;

  // The main kuliyyah of the schedule
  String? kuliyyah;

  SavedSchedule({
    required this.session,
    required this.semester,
    required this.title,
    required this.lastModified,
    required this.dateCreated,
    required this.fontSize,
    required this.heightFactor,
    required this.subjectTitleSetting,
    required this.kuliyyah,
  });

  @override
  String toString() {
    return '{title: $title, subjects count: ${subjects.length}, lastModified: $lastModified, dateCreated: $dateCreated, fontSize: $fontSize, heightFactor: $heightFactor,}';
  }
}
