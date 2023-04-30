import 'package:device_calendar/device_calendar.dart';

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
        end: TZDateTime.from(exam.date.add(Duration(hours: 3)),
            getLocation('Asia/Kuala_Lumpur')),
      );
      var res = await deviceCalendarPlugin.createOrUpdateEvent(event);
      if (res!.isSuccess) results[i] = true;
    }

    if (results.contains(false)) throw Exception('Error when adding events');
  }
}
