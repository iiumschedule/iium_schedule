import 'package:flutter/material.dart';

extension TimeOfDayUtils on TimeOfDay {
  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }

  /// Similar to .toString(), but without the class name
  String toRealString() {
    final String hourLabel = _addLeadingZeroIfNeeded(hour);
    final String minuteLabel = _addLeadingZeroIfNeeded(minute);

    return '$hourLabel:$minuteLabel';
  }

  /// Calculate the difference between TimeOfDay
  TimeOfDay difference(TimeOfDay other) {
    var diff = DateTime(2022, 11, 5, hour, minute)
        .difference(DateTime(2022, 11, 5, other.hour, other.minute));
    int twoDigitMinutes = diff.inMinutes.remainder(60);
    return TimeOfDay(hour: diff.inHours, minute: twoDigitMinutes);
  }
}
