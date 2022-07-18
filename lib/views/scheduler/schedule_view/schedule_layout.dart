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

import '../../../colour_palletes.dart';
import '../../../providers/saved_schedule_provider.dart';
import '../../../providers/schedule_layout_setting_provider.dart';
import '../../../util/extensions.dart';
import '../../../util/save_file.dart';
import 'rename_dialog.dart';
import 'setting_bottom_sheet.dart';
import 'subject_dialog.dart';
import 'timetable_view_widget.dart';

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
  final FToast fToast = FToast();
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
    fToast.init(context);
  }

  void takeScreenshot() async {
    SaveFile sf = SaveFile();
    RenderRepaintBoundary boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    // In debug mode Android sometimes will return !debugNeedsPrint error
    if (kDebugMode ? boundary.debugNeedsPaint : false) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
    }
    ui.Image image = await boundary.toImage(pixelRatio: 2);
    // TODO: Saves to gallery

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    // sanitize file name and change space to dash
    final filename =
        name.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '-');

    String? path = await sf.save(pngBytes, filename);

    if (kIsWeb) {
      Fluttertoast.showToast(
          msg: "Schedule will be downloaded shortly..",
          webPosition: "left",
          timeInSecForIosWeb: 3);
      return;
    }

    // show toast for windows and android
    fToast.showToast(
      toastDuration: const Duration(seconds: 3),
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors
            .grey[Theme.of(context).brightness == Brightness.dark ? 800 : 300],
        child: Text('Saved to $path'),
      ),
    );
  }

  // Save the generated schedule data to the database (Hive)
  // Also take screenshot and save to device
  void save() async {
    var scheduleData = widget.subjects.map((e) => e.toJson()).toList();
    takeScreenshot();
    Provider.of<SavedScheduleProvider>(context, listen: false).setSchedule(
        name: name, data: scheduleData, oldName: widget.initialName);
    // Fluttertoast.showToast(msg: "Saved");
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
            title: Provider.of<ScheduleLayoutSettingProvider>(context)
                        .subjectTitleSetting ==
                    SubjectTitleSetting.title
                ? e.title
                : e.code,
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
                        tooltip: 'Increase text sizes',
                        onPressed: () => setState(() => _fontSizeSubject--),
                        icon: const Icon(Icons.text_decrease_rounded),
                      ),
                      IconButton(
                        tooltip: 'Reduce text sizes',
                        onPressed: () => setState(() => _fontSizeSubject++),
                        icon: const Icon(Icons.text_increase_rounded),
                      ),
                    ],
                    IconButton(
                        onPressed: () {
                          // ooen bottomsheet
                          showModalBottomSheet(
                              context: context,
                              builder: (_) => const SettingBottomSheet());
                        },
                        icon: const Icon(Icons.settings_outlined)),
                    PopupMenuButton(
                        itemBuilder: (context) {
                          return <PopupMenuEntry>[
                            const PopupMenuItem(
                              value: 'save',
                              child: ListTile(
                                  trailing: Icon(Icons.file_download_outlined),
                                  title: Text('Save')),
                            ),
                            const PopupMenuItem(
                              // TODO: Implement share
                              value: 'share',
                              child: ListTile(
                                  trailing: Icon(Icons.send_outlined),
                                  title: Text('Share')),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem(
                              // Implement delete
                              value: 'delete',
                              child: ListTile(
                                  trailing: Icon(
                                    Icons.delete_outline,
                                  ),
                                  title: Text('Delete')),
                            ),
                          ];
                        },
                        onSelected: popupMenuHandler),
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
                          tooltip: "Zoom in (increase height)",
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
                          tooltip: "Zoom out (decrease height)",
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
                      tooltip: "Go full screen",
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

  void popupMenuHandler(value) {
    switch (value) {
      case 'save':
        save();
        break;
      case 'share':
        // TODO: Implement share
        Fluttertoast.showToast(msg: "Not implemented yet");
        break;
      case 'delete':
        // TODO: Implement delete
        Fluttertoast.showToast(msg: "Not implemented yet");
        break;
    }
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
