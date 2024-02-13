import 'package:isar/isar.dart';

import '../features/schedule_viewer/saved/utils/lane_events_util.dart';
import 'saved_subject.dart';

part 'saved_schedule.g.dart';

enum SubjectTitleSetting { title, courseCode }

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

  @enumerated
  ExtraInfo extraInfo = ExtraInfo.none;

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
    required this.extraInfo,
  });

  @override
  String toString() {
    return '{title: $title, subjects count: ${subjects.length}, lastModified: $lastModified, dateCreated: $dateCreated, fontSize: $fontSize, heightFactor: $heightFactor,}';
  }
}
