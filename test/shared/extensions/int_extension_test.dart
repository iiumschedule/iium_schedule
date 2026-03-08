import 'package:albiruni/albiruni.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iium_schedule/shared/enums/day_enum.dart';
import 'package:iium_schedule/shared/extensions/int_extension.dart';

void main() {
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
}
