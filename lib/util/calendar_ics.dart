import 'dart:io';

import 'package:ical/serializer.dart';
import 'package:path_provider/path_provider.dart';

import '../isar_models/final_exam.dart';

/// Calendar utility to add final exams to calendar
///
/// TODO: ICS for subjects
/// https://github.com/iqfareez/iium_schedule/issues/65
/// https://github.com/iqfareez/iium_schedule/pull/64
/// See [lib/util/calTec.dart]
class CalendarIcs {
  /// Generate ICS content for final exams
  static String _generateIcsContent(List<FinalExam> upcomingFinalExams) {
    ICalendar cal = ICalendar();
    for (var exam in upcomingFinalExams) {
      cal.addElement(
        IEvent(
          uid: exam.courseCode,
          start: exam.date,
          end: exam.date.add(const Duration(hours: 3)),
          status: IEventStatus.CONFIRMED,
          location: exam.venue,
          description: '${exam.title} final exam',
          summary: '${exam.courseCode} Exam',
        ),
      );
    }

    return cal.serialize();
  }

  /// Generate ICS File and save to diretory
  static Future<File> generateIcsFile(
      List<FinalExam> upcomingFinalExams) async {
    Directory? directory;

    try {
      // Windows
      var dirs = await getExternalStorageDirectories();
      directory = dirs?.first;
    } on UnimplementedError {
      // Android
      directory = await getApplicationDocumentsDirectory();
    }

    var icsContent = _generateIcsContent(upcomingFinalExams);

    return await File('${directory?.path}/exam_calendar.ics')
        .writeAsString(icsContent);
  }

  /// TODO: For web, download the file to user's computer
  static void downloadIcsFile(List<FinalExam> upcomingFinalExams) {
    throw UnimplementedError();
  }
}
