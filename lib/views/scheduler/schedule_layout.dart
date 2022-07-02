import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:albiruni/albiruni.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  State<ScheduleLayout> createState() => _ScheduleLayoutState();
}

class _ScheduleLayoutState extends State<ScheduleLayout> {
  final _colorPallete = [...ColourPalletes.pallete1]; // add more
  int _startHour = 10; // pukul 10 am
  int _endHour = 17; // pukul 5 pm
  final GlobalKey _globalKey = GlobalKey();
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

  void takeScreenshot() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    // TODO: Sometimes error !debugNeedsPaint': is not true
    if (kDebugMode ? boundary.debugNeedsPaint : false) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      //   ui.Image image = await boundary.toImage();
    }
    ui.Image image = await boundary.toImage();
    // TODO: Saves to gallery
    // TODO: Handle Windows and the web
    final folderDirectory =
        await Directory('/storage/emulated/0/Pictures/IIUM Schedule').create();
    final directory = folderDirectory.path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    // sanitize file name
    final fileName = name.replaceAll(RegExp(r'[^\w\s]+'), '');
    File imgFile = File('$directory/$fileName.png');
    print(directory);
    imgFile.writeAsBytes(pngBytes);
  }

  void save() async {
    var scheduleData = widget.subjects.map((e) => e.toJson()).toList();
    takeScreenshot();
    Provider.of<SavedScheduleProvider>(context, listen: false).setSchedule(
        name: name, data: scheduleData, oldName: widget.initialName);
    Fluttertoast.showToast(msg: "Saved");
  }

  @override
  Widget build(BuildContext context) {
    List<LaneEvents> laneEventsList = [];
    // var _brightness = SchedulerBinding.instance!.window.platformBrightness;
    var brightness = Theme.of(context).brightness;
    // Find if there any subject in each day
    for (var i = 1; i <= 7; i++) {
      List<Subject?> extractedSubjects = [];

      // Seperate subject into their day and rebuild

      for (var subject in widget.subjects) {
        var dayTimes = subject.dayTime.where((element) => element?.day == i);
        extractedSubjects.addAll(
          dayTimes.map((e) => Subject(
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

      var tableEvents = extractedSubjects.map(
        (e) {
          var start = TimeOfDay(
              hour: int.parse(e!.dayTime.first!.startTime.split(":").first),
              minute: int.parse(e.dayTime.first!.startTime.split(":").last));
          var end = TimeOfDay(
              hour: int.parse(e.dayTime.first!.endTime.split(":").first),
              minute: int.parse(e.dayTime.first!.endTime.split(":").last));

          if (start.hour < _startHour) _startHour = start.hour;

          if (end.hour > _endHour) _endHour = end.hour;

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
            start: TableEventTime(hour: start.hour, minute: start.minute),
            end: TableEventTime(hour: end.hour, minute: end.minute),
            onTap: () => showDialog(
              context: context,
              builder: (_) => SubjectDialog(
                subject: e,
                color: _colorPallete[subjIndex],
                start: start,
                end: end,
              ),
            ),
          );
        },
      );
      Lane lane = Lane(
        backgroundColor: brightness == Brightness.light
            ? const Color(0xfffafafa)
            : const Color(0xff303030),
        name: i.englishDay().substring(0, 3).toUpperCase(),
        textStyle: TextStyle(
          color:
              brightness == Brightness.light ? Colors.black38 : Colors.white38,
        ),
      );

      var laneEvents = LaneEvents(lane: lane, events: tableEvents.toList());

      laneEventsList.add(laneEvents);
    }

    // Remove day without classes from last day
    for (var i = 6; i > 0; i--) {
      if (laneEventsList[i].events.isEmpty) {
        laneEventsList.removeLast();
      } else {
        break;
      }
    }
    return RepaintBoundary(
      key: _globalKey,
      child: GestureDetector(
        onTap: _hideFab ? () => setState(() => _hideFab = !_hideFab) : null,
        child: Scaffold(
          appBar: _isFullScreen
              ? null
              : AppBar(
                  title: InkWell(
                      onTap: () async {
                        final scheduleNameController =
                            TextEditingController(text: name);
                        String? newName = await showDialog(
                            context: context,
                            builder: (_) => RenameDialog(
                                scheduleNameController:
                                    scheduleNameController));

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
                laneEventsList: laneEventsList,
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
                    if (kIsWeb || !Platform.isAndroid)
                      const SizedBox(height: 5),
                    if (_itemHeight >= 44)
                      FloatingActionButton(
                          heroTag: "btnZoom-",
                          mini: true,
                          child: const Icon(Icons.zoom_out),
                          onPressed: () {
                            setState(() => _itemHeight -= 2);
                          }),
                    if (kIsWeb || !Platform.isAndroid)
                      const SizedBox(height: 5),
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
    var actionButtonColour = Theme.of(context).textTheme.bodyLarge!.color;

    var duration = _end.difference(_start);
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
            subtitle: Text(duration.minute == 0
                ? 'Duration ${duration.hour}h'
                : 'Duration ${duration.hour}h ${duration.minute}m'),
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
              style: TextStyle(color: actionButtonColour),
            )),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: TextStyle(color: actionButtonColour),
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
