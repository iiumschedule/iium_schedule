
import 'package:flutter_timetable_view/src/models/lane.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';

class LaneEvents {
  final Lane lane;

  final List<TableEvent> events;

  LaneEvents({
    required this.lane,
    required this.events,
  });
}
