import 'package:isar/isar.dart';

part 'saved_final_exam.g.dart';

@collection
class SavedFinalExam {
  Id? id;

  /// Subject course code
  String courseCode;

  /// Subject name
  String courseTitle;

  /// Exam's date and start time
  DateTime dateTime;

  /// Candidate's seat number
  int seatNumber;

  /// Exam venue
  String venue;

  /// Final exam information
  SavedFinalExam({
    required this.courseCode,
    required this.courseTitle,
    required this.dateTime,
    required this.seatNumber,
    required this.venue,
  });
}
