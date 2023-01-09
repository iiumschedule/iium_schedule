import 'package:albiruni/albiruni.dart';
import 'package:isar/isar.dart';

part 'saved_daytime.g.dart';

@collection
class SavedDaytime {
  Id? id;

  /// Day in integer. 0 is Sunday, 1 is Monday and so on.
  late byte day;

  /// Starting time of the class
  late String startTime;

  /// Ending time of the class.
  late String endTime;

  SavedDaytime(
      {required this.day, required this.startTime, required this.endTime});

  @override
  String toString() {
    return '{day: $day, startTime: $startTime, endTime: $endTime}';
  }

  /// Input [DayTime] and return [SavedDaytime]
  SavedDaytime.fromDayTime({required DayTime daytime})
      : this(
            day: daytime.day,
            startTime: daytime.startTime,
            endTime: daytime.endTime);

  /// Return [DayTime] from [SavedDaytime]
  DayTime toDayTime() {
    return DayTime(day: day, startTime: startTime, endTime: endTime);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedDaytime &&
          runtimeType == other.runtimeType &&
          day == other.day &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  int get hashCode => day.hashCode ^ startTime.hashCode ^ endTime.hashCode;
}
