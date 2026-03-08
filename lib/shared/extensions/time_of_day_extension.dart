import 'package:flutter/material.dart';

extension TimeOfDayUtils on TimeOfDay {
  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }

  /// Similar to .toString(), but without the class name.
  ///
  /// Pass [use24Hour] = false to format in 12-hour style (e.g. "8:30 am").
  String toRealString({bool use24Hour = true}) {
    if (use24Hour) {
      final String hourLabel = _addLeadingZeroIfNeeded(hour);
      final String minuteLabel = _addLeadingZeroIfNeeded(minute);
      return '$hourLabel:$minuteLabel';
    } else {
      final int displayHour = hour % 12 == 0 ? 12 : hour % 12;
      final String minuteLabel = _addLeadingZeroIfNeeded(minute);
      final String period = hour < 12 ? 'am' : 'pm';
      return '$displayHour:$minuteLabel $period';
    }
  }

  /// Calculate the difference between TimeOfDay
  TimeOfDay difference(TimeOfDay other) {
    var diff = DateTime(2022, 11, 5, hour, minute)
        .difference(DateTime(2022, 11, 5, other.hour, other.minute));
    int twoDigitMinutes = diff.inMinutes.remainder(60);
    return TimeOfDay(hour: diff.inHours, minute: twoDigitMinutes);
  }
}
