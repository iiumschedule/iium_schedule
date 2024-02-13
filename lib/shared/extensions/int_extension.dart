import '../enums/day_enum.dart';

extension DayName on int {
  /// Convert int to human readable day name
  String englishDay() => Day.values[this - 1].name;
}
