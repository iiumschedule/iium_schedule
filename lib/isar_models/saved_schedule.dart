import 'package:isar/isar.dart';

import '../enums/subject_title_setting_enum.dart';
import 'saved_subject.dart';

part 'saved_schedule.g.dart';

@collection
class SavedSchedule {
  Id? id;

  String? title;

  final subjects = IsarLinks<SavedSubject>();

  /// Datetime saved in to isoString
  String lastModified;

  String dateCreated;

  double fontSize;

  double heightFactor;

  @enumerated // same as EnumType.ordinal
  SubjectTitleSetting subjectTitleSetting;

  String session;

  int semester;

  SavedSchedule({
    required this.session,
    required this.semester,
    required this.title,
    required this.lastModified,
    required this.dateCreated,
    required this.fontSize,
    required this.heightFactor,
    required this.subjectTitleSetting,
  });

  @override
  String toString() {
    return '{title: $title, subjects count: ${subjects.length}, lastModified: $lastModified, dateCreated: $dateCreated, fontSize: $fontSize, heightFactor: $heightFactor,}';
  }
}
