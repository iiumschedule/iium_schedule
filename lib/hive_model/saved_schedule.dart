import 'package:hive/hive.dart';

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

  SavedSchedule(
      {required this.title,
      required this.subjects,
      required this.lastModified});

  @override
  String toString() {
    return '{title: $title, subjects: $subjects}';
  }
}
