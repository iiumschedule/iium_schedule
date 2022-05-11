import 'package:albiruni/albiruni.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

extension TextBeautify on String {
  /// Remove dot zero. Ezample: `3.0` become `3`
  String removeTrailingDotZero() => replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
}

extension AlbiruniDayTime on DayTime {
  /// Convert int to human readable day name
  String englishDay() => describeEnum(Day.values[day - 1]);
}

extension DayName on int {
  /// Convert int to human readable day name
  String englishDay() => describeEnum(Day.values[this - 1]);
}

extension Utility on BuildContext {
  /// Move to next text field
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (FocusScope.of(this).focusedChild!.context == null);
  }
}

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
