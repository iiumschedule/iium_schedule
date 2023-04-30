import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

import '../../util/calendar_ics.dart';

/// Ask user which calendar account to add the exams to
class CalendarChooserDialog extends StatefulWidget {
  const CalendarChooserDialog({super.key});

  @override
  State<CalendarChooserDialog> createState() => _CalendarChooserDialogState();
}

class _CalendarChooserDialogState extends State<CalendarChooserDialog> {
  late Future<List<Calendar>> futureCalendars;
  Calendar? selectedCalendar;

  /// Filter calendars to only those that are modifiable so events can be added
  Future<List<Calendar>> getModifiableCalendars() {
    var allCalendars = CalendarIcs.getCalendarAccounts();
    return allCalendars.then((value) {
      value.removeWhere((element) => element.isReadOnly!);
      return value;
    });
  }

  @override
  void initState() {
    super.initState();
    futureCalendars = getModifiableCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: FutureBuilder(
        future: futureCalendars,
        builder: (context, AsyncSnapshot<List<Calendar>> snapshot) {
          if (snapshot.hasData) {
            var accounts = snapshot.data!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select the calendar to add the exams to'),
                const SizedBox(height: 10),
                DropdownButton<Calendar>(
                  value: selectedCalendar ?? accounts.first,
                  onChanged: (value) =>
                      setState(() => selectedCalendar = value),
                  items: accounts.map((e) {
                    return DropdownMenuItem(value: e, child: Text(e.name!));
                  }).toList(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(
                      context, selectedCalendar ?? accounts.first),
                  child: const Text('Add to calendar'),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
