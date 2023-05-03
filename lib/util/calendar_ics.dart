import 'dart:io';

import 'package:device_calendar/device_calendar.dart';
import 'package:ical/serializer.dart';
import 'package:path_provider/path_provider.dart';

import '../isar_models/final_exam.dart';

/// Calendar utility to add final exams to calendar
class CalendarIcs {
  /// Retrieve all calendars from the device
  static Future<List<Calendar>> getCalendarAccounts() async {
    DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
    var res = await deviceCalendarPlugin.retrieveCalendars();
    if (res.isSuccess) return res.data!.map((e) => e).toList();
    throw Exception('Error when retrieving calendars');
  }

  /// Add final exams to calendar
  static Future<void> addFinalExamToCalendar(
      String calendarId, List<FinalExam> upcomingFinalExams) async {
    DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();

    int subjectLength = upcomingFinalExams.length;
    List<bool> results = List.filled(subjectLength, false);

    for (int i = 0; i < upcomingFinalExams.length; i++) {
      var exam = upcomingFinalExams[i];
      final Event event = Event(
        calendarId,
        title: '${exam.courseCode} exam',
        description: 'Final Exam for ${exam.courseCode} ${exam.title}',
        location: exam.venue,
        start: TZDateTime.from(exam.date, getLocation('Asia/Kuala_Lumpur')),
        end: TZDateTime.from(exam.date.add(const Duration(hours: 3)),
            getLocation('Asia/Kuala_Lumpur')),
      );
      var res = await deviceCalendarPlugin.createOrUpdateEvent(event);
      if (res!.isSuccess) results[i] = true;
    }

    if (results.contains(false)) throw Exception('Error when adding events');
  }

  static Future<String> generateIcsFile(
      List<FinalExam> upcomingFinalExams) async {
    ICalendar cal = ICalendar();
    for (var exam in upcomingFinalExams) {
      cal.addElement(
        IEvent(
          uid: exam.courseCode,
          start: exam.date,
          end: exam.date.add(const Duration(hours: 3)),
          status: IEventStatus.CONFIRMED,
          location: exam.venue,
          description: '${exam.title} exam',
          summary: '${exam.courseCode} exam',
        ),
      );
    }

    // generate ics file
    final directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/calendar.ics');

    String ics = cal.serialize();
    file.writeAsString(ics);

    return file.path;
  }
}
