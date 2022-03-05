import 'dart:io';

import 'package:albiruni/albiruni.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

import '../../constant.dart';
import '../../util/extensions.dart';

class ScheduleLayout extends StatefulWidget {
  const ScheduleLayout(this.subjects, {Key? key}) : super(key: key);

  final List<Subject> subjects;

  @override
  _ScheduleLayoutState createState() => _ScheduleLayoutState();
}

class _ScheduleLayoutState extends State<ScheduleLayout> {
  final _colorPallete = [...ColourPallete.pallete1]; // add more
  int startHour = 10; // pukul 10 am
  int endHour = 17; // pukul 5 pm

  @override
  void initState() {
    super.initState();
    _colorPallete.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    List<LaneEvents> _laneEventsList = [];
    // var _brightness = SchedulerBinding.instance!.window.platformBrightness;
    var _brightness = Theme.of(context).brightness;
    // Find if there any subject in each day
    for (var i = 1; i <= 7; i++) {
      List<Subject?> _extractedSubjects = [];

      // Seperate subject into their day and rebuild

      for (var subject in widget.subjects) {
        var _dayTimes = subject.dayTime.where((element) => element?.day == i);
        _extractedSubjects.addAll(
          _dayTimes.map((e) => Subject(
                code: subject.code,
                sect: subject.sect,
                title: subject.title,
                chr: subject.chr,
                venue: subject.venue,
                lect: subject.lect,
                dayTime: [e],
              )),
        );
      }

      var _tableEvents = _extractedSubjects.map(
        (e) {
          var _start = TimeOfDay(
              hour: int.parse(e!.dayTime.first!.startTime.split(":").first),
              minute: int.parse(e.dayTime.first!.startTime.split(":").last));
          var _end = TimeOfDay(
              hour: int.parse(e.dayTime.first!.endTime.split(":").first),
              minute: int.parse(e.dayTime.first!.endTime.split(":").last));

          if (_start.hour < startHour) startHour = _start.hour;

          if (_end.hour > endHour) endHour = _end.hour;

          // choose same and unique colour to each subject
          var subjIndex =
              widget.subjects.indexWhere((element) => element.code == e.code);

          Color textColor = _colorPallete[subjIndex].computeLuminance() > 0.5
              ? Colors.black
              : Colors.white;

          return TableEvent(
            textStyle: TextStyle(fontSize: 10, color: textColor),
            title: e.title,
            backgroundColor: _colorPallete[subjIndex],
            start: TableEventTime(
              hour: _start.hour,
              minute: _start.minute,
            ),
            end: TableEventTime(
              hour: _end.hour,
              minute: _end.minute,
            ),
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(e.code),
              ),
            ),
          );
        },
      );
      Lane _lane = Lane(
          backgroundColor: _brightness == Brightness.light
              ? const Color(0xfffafafa)
              : const Color(0xff303030),
          name: i.englishDay().substring(0, 3).toUpperCase(),
          textStyle: TextStyle(
              color: _brightness == Brightness.light
                  ? Colors.black38
                  : Colors.white38),
          width: 80);

      var _laneEvents = LaneEvents(lane: _lane, events: _tableEvents.toList());

      _laneEventsList.add(_laneEvents);
    }

    // Remove day without classes from last day
    for (var i = 6; i > 0; i--) {
      if (_laneEventsList[i].events.isEmpty) {
        _laneEventsList.removeLast();
      } else {
        break;
      }
    }
    return Scaffold(
      appBar: (kIsWeb || !Platform.isAndroid)
          ? AppBar(
              title: const Text("Timetable"),
            )
          : null,
      body: SafeArea(
        child: TimetableViewWidget(
            startHour: startHour,
            endHour: endHour,
            laneEventsList: _laneEventsList),
      ),
    );
  }
}

class TimetableViewWidget extends StatelessWidget {
  const TimetableViewWidget({
    Key? key,
    required this.startHour,
    required this.endHour,
    required List<LaneEvents> laneEventsList,
  })  : _laneEventsList = laneEventsList,
        super(key: key);

  final int startHour;
  final int endHour;
  final List<LaneEvents> _laneEventsList;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return TimetableView(
        timetableStyle: TimetableStyle(
            timeItemTextColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black38
                : Colors.white38,
            timeItemWidth: 50,
            laneWidth: constraints.maxWidth /
                (_laneEventsList.length +
                    .8), // responsive layout while providing little padding at the end
            laneColor: Theme.of(context).scaffoldBackgroundColor,
            timelineColor: Theme.of(context).scaffoldBackgroundColor,
            mainBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            timelineItemColor: Theme.of(context).scaffoldBackgroundColor,
            startHour: startHour,
            endHour: endHour),
        laneEventsList: _laneEventsList,
      );
    });
  }
}
