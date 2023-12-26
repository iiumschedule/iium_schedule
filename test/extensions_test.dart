import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iium_schedule/shared/enums/day_enum.dart';
import 'package:iium_schedule/shared/extensions/int_extension.dart';
import 'package:iium_schedule/shared/extensions/string_extension.dart';
import 'package:iium_schedule/shared/extensions/time_of_day_extension.dart';

void main() {
  test("Remove trailing zeros test", () {
    var testValue = '3.0';
    expect(testValue.removeTrailingDotZero(), '3');

    // current implementation did not supports more that one traiiling zero
    expect(testValue, isNot('3'));
  });

  test("Convert DayTime's day to Day name", () {
    var days = [
      Day.monday,
      Day.tuesday,
      Day.wednesday,
      Day.thursday,
      Day.friday,
      Day.saturday,
      Day.sunday,
    ];

    List<DayTime> dayTimes = List.generate(
        7,
        (index) =>
            DayTime(day: index + 1, startTime: '08:00', endTime: '09:00'));

    for (var i = 0; i < dayTimes.length; i++) {
      // 1 : Monday etc.
      expect(dayTimes[i].day.englishDay(), days[i].name);
    }
  });

  test("Convert int to Day name", () {
    var days = [
      Day.monday,
      Day.tuesday,
      Day.wednesday,
      Day.thursday,
      Day.friday,
      Day.saturday,
      Day.sunday,
    ];
    List<int> daysInt = [1, 2, 3, 4, 5, 6, 7];

    for (var i = 0; i < daysInt.length; i++) {
      // 1 : Monday etc.
      expect(daysInt[i].englishDay(), days[i].name);
    }
  });

  test("TimeOfDay toString without classname", () {
    var examples = const [
      TimeOfDay(hour: 9, minute: 23),
      TimeOfDay(hour: 23, minute: 10)
    ];
    var expected = ['09:23', '23:10'];

    for (var i = 0; i < examples.length; i++) {
      expect(examples[i].toRealString(), expected[i]);
    }
  });

  test("Difference between TimeOfDay", () {
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
