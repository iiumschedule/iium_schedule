import 'dart:io';

import 'package:albiruni/albiruni.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

import '../../../isar_models/saved_daytime.dart';
import '../../../isar_models/saved_schedule.dart';
import '../../../isar_models/saved_subject.dart';
import '../../../providers/schedule_maker_provider.dart';
import '../../../util/colour_palletes.dart';
import '../../../providers/schedule_layout_setting_provider.dart';
import '../../../util/extensions.dart';
import '../../../util/lane_events_util.dart';
import '../../../util/my_ftoast.dart';
import '../../saved_schedule/saved_schedule_layout.dart';
import '../../saved_schedule/schedule_export_page.dart';
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
  final _colorPallete = [
    // ...ColourPalletes.pallete3,
    ...ColourPalletes.pallete1
  ]; // colour pallete to be included in initial generation
  final GlobalKey _globalKey = GlobalKey();

  int _startHour = 10; // pukul 10 am
  int _endHour = 17; // pukul 5 pm
  double _itemHeight = 60.0;
  double _fontSizeSubject = 9;
  bool _isFullScreen = false;
  bool _hideFab = false;

  // Saved the hex colour value mapped to its subject
  Map<String, int> tempHexColour = {};

  late String name;

  @override
  void initState() {
    super.initState();
    _colorPallete.shuffle();
    name = widget.initialName;

    Provider.of<ScheduleLayoutSettingProvider>(context, listen: false)
        .initializeSetting();
  }

  // Save the generated schedule data to the database (Isar)
  Future<int> save() async {
    Isar isar = Isar.getInstance()!;
    late int savedId;

    var albiruni =
        Provider.of<ScheduleMakerProvider>(context, listen: false).albiruni!;
    var kulliyah =
        Provider.of<ScheduleMakerProvider>(context, listen: false).kulliyah;

    await isar.writeTxn(() async {
      var isarSchedule = SavedSchedule(
        session: albiruni.session,
        semester: albiruni.semester,
        title: name,
        lastModified: DateTime.now(),
        dateCreated: DateTime.now(),
        fontSize: _fontSizeSubject,
        heightFactor: _itemHeight,
        subjectTitleSetting:
            Provider.of<ScheduleLayoutSettingProvider>(context, listen: false)
                .subjectTitleSetting,
        kuliyyah: kulliyah,
        extraInfo:
            Provider.of<ScheduleLayoutSettingProvider>(context, listen: false)
                .extraInfo,
      );

      savedId = await isar.savedSchedules.put(isarSchedule);

      for (final subject in widget.subjects) {
        var isarSubject = SavedSubject(
          code: subject.code,
          sect: subject.sect,
          title: subject.title,
          chr: subject.chr,
          venue: subject.venue,
          lect: subject.lect,
          subjectName: subject.title,
          hexColor: tempHexColour[subject.code],
        );

        await isar.savedSubjects.put(isarSubject);
        isarSchedule.subjects.add(isarSubject);

        isarSchedule.subjects.save();

        var isarDayTimes = <SavedDaytime>[];

        for (final dayTime in subject.dayTime) {
          isarDayTimes.add(SavedDaytime(
            day: dayTime!.day,
            startTime: dayTime.startTime,
            endTime: dayTime.endTime,
          ));
        }

        await isar.savedDaytimes.putAll(isarDayTimes);
        isarSubject.dayTimes.addAll(isarDayTimes);
        await isarSubject.dayTimes.save();
      }
    });
    return savedId;
  }

  @override
  Widget build(BuildContext context) {
    List<LaneEvents> laneEventsList = [];
    // below is something similar to `LaneEventsUtil.laneEvents()`, we need
    // to refactor this (combine with above implementation)

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

          tempHexColour.addAll({
            e.code: _colorPallete[subjIndex].value,
          });

          var extraInfoType =
              Provider.of<ScheduleLayoutSettingProvider>(context).extraInfo;

          String? extra;

          switch (extraInfoType) {
            case ExtraInfo.section:
              extra = 'Sect. ${e.sect}';
              break;
            case ExtraInfo.venue:
              extra = e.venue ?? '-';
              break;
            case ExtraInfo.none:
              extra = null;
              break;
          }

          return TableEvent(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                color: _colorPallete[subjIndex]),
            textStyle: TextStyle(
                fontSize: _fontSizeSubject,
                color: textColor,
                fontFamily: 'Inter'),
            title: Provider.of<ScheduleLayoutSettingProvider>(context)
                        .subjectTitleSetting ==
                    SubjectTitleSetting.title
                ? e.title
                : e.code,
            // backgroundColor: _colorPallete[subjIndex],
            subtitle: extra,
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
        backgroundColor: Theme.of(context).colorScheme.background,
        name: i.englishDay().substring(0, 3).toUpperCase(),
        textStyle: TextStyle(
          fontFamily: 'Inter',
          color: Theme.of(context).colorScheme.onBackground,
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
          backgroundColor: Theme.of(context).colorScheme.background,
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
                      },
                      child: Text(
                        name,
                        overflow: TextOverflow.fade,
                      )),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                                content: Text(
                                    'To add more subjects, save the schedule first.\n\nTap on menu \u22EE then choose "Save to app"'),
                              )),
                    ),
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
                          // open bottomsheet
                          showModalBottomSheet(
                              context: context,
                              builder: (_) => const SettingBottomSheet());
                        },
                        tooltip: 'Customization',
                        icon: const Icon(Icons.settings_outlined)),
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return <PopupMenuEntry>[
                          PopupMenuItem(
                            child: const Text('Save to app'),
                            onTap: () async {
                              var key = await save();
                              if (!mounted) return;
                              MyFtoast.show(
                                context,
                                'Saved. The schedule can the found from the main menu. ${kDebugMode ? '$key*' : ''}',
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SavedScheduleLayout(id: key),
                                ),
                                (route) => route.isFirst,
                              );
                            },
                          ),
                          PopupMenuItem(
                            child: Text(kIsWeb
                                ? 'Export'
                                : Platform.isAndroid
                                    ? 'Export & share'
                                    : 'Export'),
                            onTap: () async {
                              final navigator = Navigator.of(context);
                              // needed as described in https://stackoverflow.com/a/69589313/13617136
                              await Future.delayed(Duration.zero);
                              navigator.push(
                                MaterialPageRoute(
                                  builder: (_) => ScheduleExportPage(
                                      laneEventsList: laneEventsList,
                                      startHour: _startHour,
                                      endHour: _endHour,
                                      scheduleTitle: name,
                                      itemHeight: _itemHeight),
                                ),
                              );
                            },
                          ),
                          // const PopupMenuDivider(),
                          // const PopupMenuItem(
                          //   // TODO: Implement delete
                          //   value: 'discard',
                          //   child: Text('Discard'),
                          // ),
                        ];
                      },
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
