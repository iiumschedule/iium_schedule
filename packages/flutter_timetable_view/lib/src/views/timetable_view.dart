import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:flutter_timetable_view/src/utils/utils.dart';
import 'package:flutter_timetable_view/src/views/controller/timetable_view_controller.dart';
import 'package:flutter_timetable_view/src/views/diagonal_scroll_view.dart';
import 'package:flutter_timetable_view/src/views/lane_view.dart';

class TimetableView extends StatefulWidget {
  final List<LaneEvents> laneEventsList;
  final TimetableStyle timetableStyle;

  const TimetableView({
    super.key,
    required this.laneEventsList,
    this.timetableStyle = const TimetableStyle(),
  });

  @override
  _TimetableViewState createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView>
    with TimetableViewController {
  @override
  void initState() {
    initController();
    super.initState();
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Corner(
          timetableStyle: widget.timetableStyle,
        ),
        MainContent(
            laneEventsList: widget.laneEventsList,
            timetableStyle: widget.timetableStyle,
            onScroll: onScroll,
            horizontalPixelsStream: horizontalPixelsStream,
            verticalPixelsStream: verticalPixelsStream),
        TimelineList(
            timetableStyle: widget.timetableStyle,
            verticalScrollController: verticalScrollController),
        LaneList(
            timetableStyle: widget.timetableStyle,
            horizontalScrollController: horizontalScrollController,
            laneEventsList: widget.laneEventsList),
      ],
    );
  }
}

class Corner extends StatelessWidget {
  const Corner({super.key, required this.timetableStyle});
  final TimetableStyle timetableStyle;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: SizedBox(
        width: timetableStyle.timeItemWidth,
        height: timetableStyle.laneHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(color: timetableStyle.cornerColor),
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent(
      {super.key,
      required this.laneEventsList,
      required this.timetableStyle,
      required this.onScroll,
      required this.horizontalPixelsStream,
      required this.verticalPixelsStream});
  final TimetableStyle timetableStyle;
  final List<LaneEvents> laneEventsList;
  final Function(dynamic) onScroll;
  final StreamController<dynamic> horizontalPixelsStream;
  final StreamController<dynamic> verticalPixelsStream;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: timetableStyle.timeItemWidth,
        top: timetableStyle.laneHeight,
      ),
      child: DiagonalScrollView(
        horizontalPixelsStreamController: horizontalPixelsStream,
        verticalPixelsStreamController: verticalPixelsStream,
        onScroll: onScroll,
        maxWidth: laneEventsList.length * timetableStyle.laneWidth,
        maxHeight: (timetableStyle.endHour - timetableStyle.startHour) *
            timetableStyle.timeItemHeight,
        child: IntrinsicHeight(
          child: Row(
            children: laneEventsList.map((laneEvents) {
              return LaneView(
                events: laneEvents.events,
                timetableStyle: timetableStyle,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class TimelineList extends StatelessWidget {
  const TimelineList(
      {super.key,
      required this.timetableStyle,
      required this.verticalScrollController});

  final TimetableStyle timetableStyle;
  final ScrollController verticalScrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: timetableStyle.timeItemWidth,
      padding: EdgeInsets.only(top: timetableStyle.laneHeight),
      color: timetableStyle.timelineColor,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        controller: verticalScrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          for (var i = timetableStyle.startHour;
              i < timetableStyle.endHour;
              i += 1)
            i
        ].map((hour) {
          return Container(
            height: timetableStyle.timeItemHeight,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: timetableStyle.timelineBorderColor,
                  width: 0,
                ),
              ),
              color: timetableStyle.timelineItemColor,
            ),
            child: Text(
              Utils.hourFormatter(hour, 0, false),
              style: TextStyle(color: timetableStyle.timeItemTextColor),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class LaneList extends StatelessWidget {
  const LaneList(
      {super.key,
      required this.timetableStyle,
      required this.horizontalScrollController,
      required this.laneEventsList});

  final TimetableStyle timetableStyle;
  final ScrollController horizontalScrollController;
  final List<LaneEvents> laneEventsList;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      color: timetableStyle.laneColor,
      height: timetableStyle.laneHeight,
      padding: EdgeInsets.only(left: timetableStyle.timeItemWidth),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        controller: horizontalScrollController,
        shrinkWrap: true,
        children: laneEventsList.map((laneEvents) {
          return Container(
            width: timetableStyle.laneWidth,
            height: laneEvents.lane.height,
            color: laneEvents.lane.backgroundColor,
            child: Center(
              child: Text(
                laneEvents.lane.name,
                style: laneEvents.lane.textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
