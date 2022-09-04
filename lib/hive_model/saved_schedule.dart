import 'package:hive/hive.dart';

import '../enums/subject_title_setting_enum.dart';
import 'saved_subject.dart';

part 'saved_schedule.g.dart';

@HiveType(typeId: 0)
class SavedSchedule extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  List<SavedSubject>? subjects;

  /// Datetime saved in to isoString
  @HiveField(2)
  String lastModified;

  @HiveField(3)
  String dateCreated;

  @HiveField(4)
  double fontSize;

  @HiveField(5)
  double heightFactor;

  @HiveField(6, defaultValue: SubjectTitleSetting.title)
  SubjectTitleSetting subjectTitleSetting;

  SavedSchedule({
    required this.title,
    required this.subjects,
    required this.lastModified,
    required this.dateCreated,
    required this.fontSize,
    required this.heightFactor,
    required this.subjectTitleSetting,
  });

  @override
  String toString() {
    return '{title: $title, subjects count: ${subjects?.length}, lastModified: $lastModified, dateCreated: $dateCreated, fontSize: $fontSize, heightFactor: $heightFactor}';
  }

  @override
  Future<void> save() {
    lastModified = DateTime.now().toString(); // update last modified time
    return super.save();
  }
}
