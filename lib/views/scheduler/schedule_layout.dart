import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../colour_palletes.dart';
import '../../providers/saved_schedule_provider.dart';
import '../../util/extensions.dart';

class ScheduleLayout extends StatefulWidget {
  const ScheduleLayout(
      {Key? key, required this.initialName, required this.subjects})
      : super(key: key);

  final String initialName;
  final List<Subject> subjects;

  @override
  _ScheduleLayoutState createState() => _ScheduleLayoutState();
}

class _ScheduleLayoutState extends State<ScheduleLayout> {
  final _colorPallete = [...ColourPallete.pallete1]; // add more
  int _startHour = 10; // pukul 10 am
  int _endHour = 17; // pukul 5 pm

  double _itemHeight = 60.0;

  late String name;

  bool _isFullScreen = false;
  bool _hideFab = false;

  @override
  void initState() {
    super.initState();
    _colorPallete.shuffle();
    name = widget.initialName;
  }

  void save() {
    var scheduleData = widget.subjects.map((e) => e.toJson()).toList();

    Provider.of<SavedScheduleProvider>(context, listen: false).setSchedule(
        name: name, data: scheduleData, oldName: widget.initialName);
    Fluttertoast.showToast(msg: "Saved");
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

          if (_start.hour < _startHour) _startHour = _start.hour;

          if (_end.hour > _endHour) _endHour = _end.hour;

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
            start: TableEventTime(hour: _start.hour, minute: _start.minute),
            end: TableEventTime(hour: _end.hour, minute: _end.minute),
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(content: Text(e.code)),
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
    return GestureDetector(
      onTap: _hideFab ? () => setState(() => _hideFab = !_hideFab) : null,
      child: Scaffold(
        appBar: _isFullScreen
            ? null
            : AppBar(
                title: InkWell(
                    onTap: () async {
                      final _scheduleNameController =
                          TextEditingController(text: name);
                      String? newName = await showDialog(
                          context: context,
                          builder: (_) => RenameDialog(
                              scheduleNameController: _scheduleNameController));

                      if ((newName == null) || (newName.isEmpty)) return;

                      setState(() => name = newName);
                      save();
                    },
                    child: Text(name)),
                actions: [
                  IconButton(
                    tooltip: "Save",
                    onPressed: save,
                    icon: const Icon(Icons.save),
                  ),
                ],
              ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TimetableViewWidget(
              startHour: _startHour,
              endHour: _endHour,
              laneEventsList: _laneEventsList,
              itemHeight: _itemHeight,
            ),
          ),
        ),
        floatingActionButton: _hideFab
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_itemHeight <= 90)
                    FloatingActionButton(
                        heroTag: "btnZoom+",
                        mini: true,
                        child: const Icon(Icons.zoom_in),
                        onPressed: () {
                          setState(() => _itemHeight += 2);
                        }),
                  if (_itemHeight >= 52)
                    FloatingActionButton(
                        heroTag: "btnZoom-",
                        mini: true,
                        child: const Icon(Icons.zoom_out),
                        onPressed: () {
                          setState(() => _itemHeight -= 2);
                        }),
                  FloatingActionButton(
                    heroTag: "btnFull",
                    mini: true,
                    onPressed: fullscreenFabHandler,
                    child: Icon(_isFullScreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen),
                  ),
                ],
              ),
      ),
    );
  }

  void fullscreenFabHandler() {
    if (!_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      setState(() {
        _isFullScreen = true;
        _hideFab = true;
      });
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      setState(() => _isFullScreen = false);
    }
  }
}

class RenameDialog extends StatelessWidget {
  const RenameDialog({
    Key? key,
    required TextEditingController scheduleNameController,
  })  : _scheduleNameController = scheduleNameController,
        super(key: key);

  final TextEditingController _scheduleNameController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rename"),
      content: TextField(controller: _scheduleNameController),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(
          onPressed: () => Navigator.pop(context, _scheduleNameController.text),
          child: const Text("Rename"),
        ),
      ],
    );
  }
}

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
            timeItemWidth: 50,
            laneHeight: 20,
            timeItemHeight: itemHeight,
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
