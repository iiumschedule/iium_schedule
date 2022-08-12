import 'package:albiruni/albiruni.dart';
import 'package:hive/hive.dart';

import 'saved_daytime.dart';

part 'saved_subject.g.dart';

@HiveType(typeId: 1)
class SavedSubject extends HiveObject {
  /// Course Code. Example: "MCTE 3373"
  @HiveField(0)
  late String code;

  /// Name of the course. Example: "INDUSTRIAL AUTOMATION"
  @HiveField(1)
  late String title;

  /// Venue. It can be null
  @HiveField(2)
  String? venue;

  /// Section
  @HiveField(3)
  late int sect;

  /// Credit hour
  @HiveField(4)
  late double chr;

  /// List of lecturer(s) teaching the subject
  @HiveField(5)
  late List<String> lect;

  /// Day and Time for the class. It can be null.
  @HiveField(6)
  late List<SavedDaytime?> dayTime;

  /// Custom subject name set by user
  @HiveField(7)
  String? subjectName;

  /// Colour assigned to this subject
  @HiveField(8)
  int? hexColor;

  SavedSubject({
    required this.code,
    required this.sect,
    required this.title,
    required this.chr,
    required this.venue,
    required this.lect,
    required this.dayTime,
    required this.subjectName,
    required this.hexColor,
  });

  @override
  String toString() =>
      "{title: $title, subjectName: $subjectName ,venue : $venue, colour : $hexColor}";

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
          dayTime: subject.dayTime
              .map((e) => SavedDaytime(
                  day: e!.day, startTime: e.startTime, endTime: e.endTime))
              .toList(),
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
      dayTime: dayTime
          .map((e) =>
              DayTime(day: e!.day, startTime: e.startTime, endTime: e.endTime))
          .toList(),
      code: code,
      chr: chr,
    );
  }
}
