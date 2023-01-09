import 'package:albiruni/albiruni.dart';
import 'package:isar/isar.dart';

import 'saved_daytime.dart';

part 'saved_subject.g.dart';

@collection
class SavedSubject {
  Id? id;

  /// Course Code. Example: "MCTE 3373"
  late String code;

  /// Name of the course. Example: "INDUSTRIAL AUTOMATION"
  late String title;

  /// Venue. It can be null
  String? venue;

  /// Section
  late short sect;

  /// Credit hour
  late float chr;

  /// List of lecturer(s) teaching the subject
  late List<String> lect;

  /// Day and Time for the class. It can be null.
  final dayTimes = IsarLinks<SavedDaytime>();

  /// Custom subject name set by user
  String? subjectName;

  /// Colour assigned to this subject
  int? hexColor;

  SavedSubject({
    required this.code,
    required this.sect,
    required this.title,
    required this.chr,
    required this.venue,
    required this.lect,
    required this.subjectName,
    required this.hexColor,
  });

  @override
  String toString() =>
      "{title: $title, subjectName: $subjectName ,venue : $venue, colour : $hexColor, lecturers: $lect, dayTime: $dayTimes}";

  /// Input [Subject] and return [SavedSubject]
  SavedSubject.fromSubject(
      {required Subject subject, String? subjectName, int? hexColor})
      : this(
          code: subject.code,
          sect: subject.sect,
          title: subject.title,
          chr: subject.chr,
          venue: subject.venue,
          lect: subject.lect,
          subjectName: subjectName,
          hexColor: hexColor,
        );

  /// Return [Subject] from [SavedSubject]
  Subject toSubject() {
    return Subject(
      title: title,
      venue: venue,
      lect: lect,
      sect: sect,
      dayTime: dayTimes
          .map((e) =>
              DayTime(day: e.day, startTime: e.startTime, endTime: e.endTime))
          .toList(),
      code: code,
      chr: chr,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedSubject &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          sect == other.sect &&
          code == other.code &&
          dayTimes == other.dayTimes;

  @override
  int get hashCode =>
      title.hashCode ^ sect.hashCode ^ code.hashCode ^ dayTimes.hashCode;
}
