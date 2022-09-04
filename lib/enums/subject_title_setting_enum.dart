import 'package:hive_flutter/hive_flutter.dart';

part 'subject_title_setting_enum.g.dart';

@HiveType(typeId: 4)
enum SubjectTitleSetting {
  @HiveField(0)
  title,
  @HiveField(1)
  courseCode
}
