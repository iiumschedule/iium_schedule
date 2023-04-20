import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

part 'final_exam.g.dart';

enum ExamTime { am, pm }

/// Parse data from I-Ma'Luum importer for final exam
@collection
class FinalExam {
  Id? id;
  late String courseCode;
  late String title;
  late int section;
  late DateTime date;
  @enumerated
  late ExamTime time;
  late String venue;
  late int seat;

  FinalExam(
      {required this.courseCode,
      required this.title,
      required this.section,
      required this.date,
      required this.time,
      required this.venue,
      required this.seat});

  FinalExam.fromJson(Map<String, dynamic> json) {
    var format = DateFormat('dd/MM/yyyy');
    courseCode = json["courseCode"];
    title = json["title"];
    section = json["section"];
    time = json["time"] == 'AM' ? ExamTime.am : ExamTime.pm;
    // If the exam is in evening, just set the time to 2pm
    // this is useful when we want to sort these subjects
    // based on their priority
    date = format
        .parse(json["date"])
        .add(time == ExamTime.pm ? const Duration(hours: 14) : Duration.zero);
    venue = json["venue"];
    seat = json["seat"];
  }

  static List<FinalExam> fromList(List<dynamic> list) {
    return list.map((map) => FinalExam.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["courseCode"] = courseCode;
    data["title"] = title;
    data["section"] = section;
    data["date"] = date;
    data["time"] = time;
    data["venue"] = venue;
    data["seat"] = seat;
    return data;
  }

  @override
  String toString() {
    return "ImaluumExam{courseCode: $courseCode, title: $title, section: $section, date: $date, time: $time, venue: $venue, seat: $seat}";
  }
}
