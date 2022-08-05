import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../model/saved_schedule.dart';
import '../../model/saved_subject.dart';
import '../../providers/schedule_layout_setting_provider.dart';
import '../../util/extensions.dart';
import '../../util/my_ftoast.dart';
import '../../util/screenshot_widget.dart';
import '../scheduler/schedule_view/rename_dialog.dart';
import '../scheduler/schedule_view/setting_bottom_sheet.dart';
import '../scheduler/schedule_view/timetable_view_widget.dart';
import 'saved_subject_dialog.dart';

class SavedScheduleLayout extends StatefulWidget {
  const SavedScheduleLayout({Key? key, required this.savedSchedule})
      : super(key: key);

  final SavedSchedule savedSchedule;

  @override
  State<SavedScheduleLayout> createState() => _SavedScheduleLayoutState();
}

class _SavedScheduleLayoutState extends State<SavedScheduleLayout> {
  final GlobalKey _globalKey = GlobalKey();

  late List<SavedSubject> savedSubject;
  late String name;

  int _startHour = 10; // pukul 10 am
  int _endHour = 17; // pukul 5 pm
  double _itemHeight = 60.0;
  double _fontSizeSubject = 10;
  bool _isFullScreen = false;
  bool _hideFab = false;

  @override
  void initState() {
    super.initState();
    savedSubject = widget.savedSchedule.subjects!;
    name = widget.savedSchedule.title ?? "";
  }

  void takeScreenshot() async {
    var brightness = Theme.of(context).brightness;
    String? path = await ScreenshotWidget.screenshot(_globalKey, name);

    if (kIsWeb) {
      Fluttertoast.showToast(
          msg: "Schedule will be downloaded shortly..",
          webPosition: "left",
          timeInSecForIosWeb: 3);
      return;
    }

    // show toast for windows and android
    if (mounted) {
      MyFtoast.show(context, 'Saved to $path', brightness);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<LaneEvents> laneEventsList = [];
    // var _brightness = SchedulerBinding.instance!.window.platformBrightness;
    var brightness = Theme.of(context).brightness;
    // Find if there any subject in each day
    for (var i = 1; i <= 7; i++) {
      List<SavedSubject?> extractedSubjects = [];

      // Seperate subject into their day and rebuild the list
      for (var subject in savedSubject) {
        var dayTimes = subject.dayTime.where((element) => element?.day == i);
        extractedSubjects.addAll(
          dayTimes.map((e) => SavedSubject(
                subjectName: subject.subjectName,
                code: subject.code,
                sect: subject.sect,
                title: subject.title,
                chr: subject.chr,
                venue: subject.venue,
                lect: subject.lect,
                dayTime: [e],
                hexColor: subject.hexColor,
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

          // saved colour  - compute luminance & bg colour
          Color textColor = ui.Color(e.hexColor!).computeLuminance() > 0.5
              ? Colors.black
              : Colors.white;

          return TableEvent(
            textStyle: TextStyle(fontSize: _fontSizeSubject, color: textColor),
            title: Provider.of<ScheduleLayoutSettingProvider>(context)
                        .subjectTitleSetting ==
                    SubjectTitleSetting.title
                ? e.title
                : e.code,
            backgroundColor: ui.Color(e.hexColor!),
            start: TableEventTime(hour: start.hour, minute: start.minute),
            end: TableEventTime(hour: end.hour, minute: end.minute),
            onTap: () => showDialog(
              context: context,
              builder: (_) => SavedSubjectDialog(
                subject: e,
                color: ui.Color(e.hexColor!),
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

                        // save the new name and record the last modified
                        widget.savedSchedule.title = newName;
                        widget.savedSchedule.lastModified =
                            DateTime.now().toString();
                        widget.savedSchedule.save();
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
                              value: 'screenshot',
                              child: ListTile(
                                  trailing: Icon(Icons.save_alt_outlined),
                                  title: Text('Save image')),
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
      case 'screenshot':
        takeScreenshot();
        break;
      case 'share':
        // TODO: Implement share
        Fluttertoast.showToast(msg: "Not implemented yet");
        throw UnimplementedError();
      // break;
      case 'delete':
        // TODO: Implement delete
        Fluttertoast.showToast(msg: "Not implemented yet");
        throw UnimplementedError();
      // break;
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
