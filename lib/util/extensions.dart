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
  void nextInputFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (
        FocusScope.of(this).focusedChild?.context?.widget is! EditableText);
  }
}
