import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iium_schedule/shared/extensions/time_of_day_extension.dart';

void main() {
  group('TimeOfDayUtils.toRealString', () {
    test('formats in 24-hour style by default', () {
      var examples = const [
        TimeOfDay(hour: 9, minute: 23),
        TimeOfDay(hour: 23, minute: 10),
      ];
      var expected = ['09:23', '23:10'];

      for (var i = 0; i < examples.length; i++) {
        expect(examples[i].toRealString(), expected[i]);
      }
    });

    test('formats in 12-hour style when use24Hour is false', () {
      expect(
        const TimeOfDay(hour: 8, minute: 30).toRealString(use24Hour: false),
        '8:30 am',
      );
      expect(
        const TimeOfDay(hour: 14, minute: 45).toRealString(use24Hour: false),
        '2:45 pm',
      );
      expect(
        const TimeOfDay(hour: 0, minute: 0).toRealString(use24Hour: false),
        '12:00 am',
      );
      expect(
        const TimeOfDay(hour: 12, minute: 0).toRealString(use24Hour: false),
        '12:00 pm',
      );
    });
  });

  test('Difference between TimeOfDay', () {
    // exhibit 1
    var startTime = const TimeOfDay(hour: 12, minute: 00);
    var endTime = const TimeOfDay(hour: 13, minute: 00);

    var actual = endTime.difference(startTime);
    expect(actual, const TimeOfDay(hour: 1, minute: 00));

    // exhibit 2
    startTime = const TimeOfDay(hour: 2, minute: 10);
    endTime = const TimeOfDay(hour: 4, minute: 45);

    actual = endTime.difference(startTime);
    expect(actual, const TimeOfDay(hour: 2, minute: 35));
  });
}
