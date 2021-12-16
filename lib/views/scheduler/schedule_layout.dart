import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';
import '../../util/extensions.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

class ScheduleLayout extends StatefulWidget {
  const ScheduleLayout(this.subjects, {Key? key}) : super(key: key);

  final List<Subject> subjects;

  @override
  _ScheduleLayoutState createState() => _ScheduleLayoutState();
}

class _ScheduleLayoutState extends State<ScheduleLayout> {
  final List<LaneEvents> _laneEventsList = [];
  final _colorPallete = [
    const Color(0xfff94144),
    const Color(0xfff3722c),
    const Color(0xfff8961e),
    const Color(0xfff9844a),
    const Color(0xfff9c74f),
    const Color(0xff90be6d),
    const Color(0xff43aa8b),
    const Color(0xff4d908e),
    const Color(0xff577590),
    const Color(0xff277da1),
  ];
  int startHour = 10; // pukul 10 am
  int endHour = 17; // pukul 5 pm

  @override
  void initState() {
    super.initState();

    _colorPallete.shuffle();
    // Find if there any subject in each day
    for (var i = 1; i <= 7; i++) {
      Lane _lane = Lane(
          name: i.englishDay().substring(0, 3).toUpperCase(),
          textStyle: const TextStyle(color: Colors.black38),
          width: 80);

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
            onTap: () => print(e.code),
          );
        },
      );

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
  }

  final bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TimetableView(
          timetableStyle: TimetableStyle(
              timeItemTextColor: Colors.black38,
              timeItemWidth: 50,
              laneWidth: 80,
              startHour: startHour,
              endHour: endHour),
          laneEventsList: _laneEventsList,
        ),
      ),
    );
  }
}
