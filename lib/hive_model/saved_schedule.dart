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

  @HiveField(7, defaultValue: "2022/2023")
  String session;

  @HiveField(8, defaultValue: 1)
  int semester;

  @HiveField(9, defaultValue: 'ENGIN')
  String kuliyyah;

  SavedSchedule({
    required this.session,
    required this.semester,
    required this.title,
    required this.subjects,
    required this.lastModified,
    required this.dateCreated,
    required this.fontSize,
    required this.heightFactor,
    required this.subjectTitleSetting,
    required this.kuliyyah,
  });

  @override
  String toString() {
    return '{title: $title, subjects count: ${subjects?.length}, lastModified: $lastModified, dateCreated: $dateCreated, fontSize: $fontSize, heightFactor: $heightFactor, kuliyyah: $kuliyyah}';
  }

  @override
  Future<void> save() {
    lastModified = DateTime.now().toString(); // update last modified time
    return super.save();
  }
}
