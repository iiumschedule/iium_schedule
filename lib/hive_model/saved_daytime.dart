import 'package:hive/hive.dart';

part 'saved_daytime.g.dart';

@HiveType(typeId: 2)
class SavedDaytime extends HiveObject {
  /// Day in integer. 0 is Sunday, 1 is Monday and so on.
  @HiveField(0)
  late int day;

  /// Starting time of the class
  @HiveField(1)
  late String startTime;

  /// Ending time of the class.
  @HiveField(2)
  late String endTime;

  SavedDaytime(
      {required this.day, required this.startTime, required this.endTime});
}
