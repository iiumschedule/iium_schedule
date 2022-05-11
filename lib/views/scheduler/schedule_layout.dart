import 'dart:io';

import 'package:albiruni/albiruni.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../colour_palletes.dart';
import '../../providers/saved_schedule_provider.dart';
import '../../util/extensions.dart';
import '../course browser/subject_screen.dart';

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
  final _colorPallete = [...ColourPalletes.pallete1]; // add more
  int _startHour = 10; // pukul 10 am
  int _endHour = 17; // pukul 5 pm

  double _itemHeight = 60.0;
  double _fontSizeSubject = 10;

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
            textStyle: TextStyle(fontSize: _fontSizeSubject, color: textColor),
            title: e.title,
            backgroundColor: _colorPallete[subjIndex],
            start: TableEventTime(hour: _start.hour, minute: _start.minute),
            end: TableEventTime(hour: _end.hour, minute: _end.minute),
            onTap: () => showDialog(
              context: context,
              builder: (_) => SubjectDialog(
                subject: e,
                color: _colorPallete[subjIndex],
                start: _start,
                end: _end,
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
          color:
              _brightness == Brightness.light ? Colors.black38 : Colors.white38,
        ),
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
                    child: Text(
                      name,
                      overflow: TextOverflow.fade,
                    )),
                actions: [
                  if (kIsWeb || !Platform.isAndroid) ...[
                    IconButton(
                      onPressed: () => setState(() => _fontSizeSubject--),
                      icon: const Icon(Icons.text_decrease_rounded),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _fontSizeSubject++),
                      icon: const Icon(Icons.text_increase_rounded),
                    ),
                  ],
                  IconButton(
                    tooltip: "Save",
                    onPressed: save,
                    icon: const Icon(Icons.save_rounded),
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
                  if (kIsWeb || !Platform.isAndroid) const SizedBox(height: 5),
                  if (_itemHeight >= 52)
                    FloatingActionButton(
                        heroTag: "btnZoom-",
                        mini: true,
                        child: const Icon(Icons.zoom_out),
                        onPressed: () {
                          setState(() => _itemHeight -= 2);
                        }),
                  if (kIsWeb || !Platform.isAndroid) const SizedBox(height: 5),
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
      // make full screen
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

class SubjectDialog extends StatelessWidget {
  const SubjectDialog({
    Key? key,
    required Subject subject,
    required MaterialColor color,
    required TimeOfDay start,
    required TimeOfDay end,
  })  : _subject = subject,
        _color = color,
        _start = start,
        _end = end,
        super(key: key);

  final Subject _subject;
  final MaterialColor _color;
  final TimeOfDay _start;
  final TimeOfDay _end;

  @override
  Widget build(BuildContext context) {
    var _actionButtonColour = Theme.of(context).textTheme.bodyLarge!.color;

    var _duration = _end.difference(_start);
    return AlertDialog(
      backgroundColor: _color.shade50,
      title: Text(_subject.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.pin_drop_outlined),
              title: Text(_subject.venue ?? "No venue")),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.schedule_outlined,
            ),
            title: Text(
                "Starts ${_start.toRealString()}, ends ${_end.toRealString()}"),
            subtitle: Text(_duration.minute == 0
                ? 'Duration ${_duration.hour}h'
                : 'Duration ${_duration.hour}h ${_duration.minute}m'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => SubjectScreen(_subject)));
            },
            child: Text(
              'View details',
              style: TextStyle(color: _actionButtonColour),
            )),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: TextStyle(color: _actionButtonColour),
            ))
      ],
    );
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
