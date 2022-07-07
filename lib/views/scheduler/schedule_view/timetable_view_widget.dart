import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

/// Draw the actual timetable view you seen on screen
class TimetableViewWidget extends StatelessWidget {
  const TimetableViewWidget(
      {Key? key,
      required this.startHour,
      required this.endHour,
      required List<LaneEvents> laneEventsList,
      required this.itemHeight})
      : _laneEventsList = laneEventsList,
        super(key: key);

  final int startHour;
  final int endHour;
  final List<LaneEvents> _laneEventsList;
  final double itemHeight;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return TimetableView(
        timetableStyle: TimetableStyle(
          timeItemTextColor: Theme.of(context).brightness == Brightness.light
              ? Colors.black38
              : Colors.white38,
          timeItemWidth: 40,
          laneHeight: 20,
          timeItemHeight: itemHeight,
          // responsive layout while providing little padding at the end
          laneWidth: constraints.maxWidth / (_laneEventsList.length + .8),
          laneColor: Theme.of(context).scaffoldBackgroundColor,
          timelineColor: Theme.of(context).scaffoldBackgroundColor,
          mainBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          timelineItemColor: Theme.of(context).scaffoldBackgroundColor,
          startHour: startHour,
          endHour: endHour,
        ),
        laneEventsList: _laneEventsList,
      );
    });
  }
}
