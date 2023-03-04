import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:albiruni/albiruni.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

// pull-to-refresh implementation
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../isar_models/saved_daytime.dart';
import '../../isar_models/saved_schedule.dart';
import '../../isar_models/saved_subject.dart';
import '../../providers/schedule_layout_setting_provider.dart';
import '../../providers/schedule_notifier_provider.dart';
import '../../services/isar_service.dart';
import '../../util/course_validator_pass.dart';
import '../../util/kulliyyah_suggestions.dart';
import '../../util/lane_events_util.dart';
import '../../util/my_snackbar.dart';
import '../../util/subject_fetcher.dart';
import '../scheduler/schedule_view/rename_dialog.dart';
import '../scheduler/schedule_view/setting_bottom_sheet.dart';
import '../scheduler/schedule_view/timetable_view_widget.dart';
import 'add_subject_page.dart';
import 'metadata_dialog.dart';
import 'schedule_export_page.dart';

class SavedScheduleLayout extends StatefulWidget {
  const SavedScheduleLayout({Key? key, required this.id}) : super(key: key);

  // final SavedSchedule savedSchedule;
  final int id;
  // final _box = Hive.box<SavedSchedule>(kHiveSavedSchedule);

  @override
  State<SavedScheduleLayout> createState() => _SavedScheduleLayoutState();
}

class _SavedScheduleLayoutState extends State<SavedScheduleLayout> {
  final IsarService isarService = IsarService();

  bool _isFullScreen = false;
  bool _hideFab = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // Let users keep track of what is currently fetching from the IIUM's database
  String currentRefreshCourse = '';

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    // Get current schedule
    final savedSchedule = await isarService.getSavedSchedule(id: widget.id);
    // initialize course validator
    var courseValidator = CourseValidatorPass(savedSchedule!.subjects.length);
    // Get kuliyyah code (e.g: KICT) from HiveDB
    final kuliyyah = savedSchedule.kuliyyah;

    if (kuliyyah == null) {
      Fluttertoast.showToast(
          msg: 'Please set your kuliyyah in the metadata',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      _refreshController.refreshCompleted();
      return;
    }

    // Keep track of the current subject index
    var currentIndex = 0;

    // print(widget.savedSchedule.subjects);

    // Here, we loop through each of student's saved subject and get the latest data from IIUM's database
    await Future.forEach<SavedSubject>(savedSchedule.subjects.toList(),
        (subject) async {
      // Update state of the pull-to-refresh loading text
      // (We use course code instead of course name to prevent text overflowing)
      setState(() =>
          currentRefreshCourse = 'Getting latest data for ${subject.code}');

      final response = await SubjectFetcher.fetchSubjectData(
          albiruni: Albiruni(
              semester: savedSchedule.semester, session: savedSchedule.session),
          // Suggest kuliyyah based on course code (e.g: UNGS 2290 will return KIRKHS)
          kulliyyah: KulliyyahSugestions.suggest(subject.code) ?? kuliyyah,
          courseCode: subject.code,
          section: subject.sect);

      courseValidator.subjectSuccess(currentIndex++, response);
    });

    if (!courseValidator.isClearToProceed()) {
      MySnackbar.showWarn(context,
          "We're facing some issues while fetching latest data. Try again later.");
      return;
    }

    /**
     * Update student's hiveDB SavedSchedule with the latest subject
     *
     * TODO: Refactorize code as a separate method
     */

    SavedSchedule currentSchedule = savedSchedule;
    List<Subject> updatedSubjectsList = courseValidator.fetchedSubjects();

    for (var prevSubject in currentSchedule.subjects) {
      final updatedSubject = updatedSubjectsList
          .singleWhere((subject) => (subject.code == prevSubject.code));

      /**
       * In some cases, a course venue can be empty in i-Maluum and lecturers will update through
       * other platforms (i.e: Whatsapp / Microsoft Teams). Since users will override the
       * venue all by themselves, it is necessary to skip empty venue from i-Maluum
       * as it will override the current venue.
       *
       * Refer https://github.com/iqfareez/iium_schedule/pull/51#pullrequestreview-1158961053
       */

      if (updatedSubject.venue == null) continue;

      // Update venue for this subject
      prevSubject.venue = updatedSubject.venue;

      // Update lecturer's name
      prevSubject.lect = updatedSubject.lect;

      // Save to isar db
      isarService.updateSubject(prevSubject);
    }

    // Update the current schedule last modified data
    currentSchedule.lastModified = DateTime.now();
    isarService.updateSchedule(currentSchedule);

    // Save changes to HiveDB
    // https://github.com/iqfareez/iium_schedule/pull/51#discussion_r1007335660
    // currentSchedule.save();

    // Finish the refreshing state
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ScheduleNotifierProvider, ScheduleLayoutSettingProvider>(
      builder: (_, __, scheduleSetting, ___) => StreamBuilder(
        stream: isarService.listenToSavedSchedule(id: widget.id),
        builder: (context, AsyncSnapshot<SavedSchedule?> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong (${snapshot.error}})'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          snapshot.data?.subjects.loadSync();
          for (var element in snapshot.data!.subjects) {
            element.dayTimes.loadSync();
          }

          // check if links is loaded
          if (!snapshot.data!.subjects.isLoaded) {
            return const Center(child: Text('Links loading'));
          }

          var name = snapshot.data!.title ?? "";
          scheduleSetting.initializeSetting(
              titleSetting: snapshot.data!.subjectTitleSetting,
              extraInfo: snapshot.data!.extraInfo);

          LaneEventsResponse laneEventsList = LaneEventsUtil(
                  context: context,
                  fontSize: snapshot.data!.fontSize,
                  savedSubjectList: snapshot.data!.subjects.toList())
              .laneEvents();
          return GestureDetector(
            onTap: _hideFab ? () => setState(() => _hideFab = !_hideFab) : null,
            // We want all the widgets to translate its position downwards as the student swipes
            // down the TimetableViewWidget, instead of showing the boring refresh indicator
            child: RefreshConfiguration(
              // Other refresh headers can be found from https://pub.dev/packages/pull_to_refresh#screenshots
              headerBuilder: () => ClassicHeader(
                refreshingText: currentRefreshCourse,
              ),
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

                              if ((newName == null) || (newName.isEmpty)) {
                                return;
                              }
                              setState(() => name = newName);

                              // save the new name and record the last modified
                              snapshot.data!.title = newName;
                              isarService.updateSchedule(snapshot.data!);
                            },
                            child: Text(
                              name,
                              overflow: TextOverflow.fade,
                            )),
                        actions: [
                          IconButton(
                            tooltip: "Add subject",
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              var res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => AddSubjectPage(
                                    session: snapshot.data!.session,
                                    semester: snapshot.data!.semester,
                                  ),
                                ),
                              );

                              if (res == null) return;

                              // cast res as Subject
                              var subject = res as Subject;

                              var isar = Isar.getInstance()!;
                              var isarSchedule =
                                  isar.savedSchedules.getSync(widget.id);

                              await isar.writeTxn(() async {
                                var isarSubject = SavedSubject(
                                  code: subject.code,
                                  sect: subject.sect,
                                  title: subject.title,
                                  chr: subject.chr,
                                  venue: subject.venue,
                                  lect: subject.lect,
                                  subjectName: subject.title,
                                  hexColor:
                                      0xFF000000 | (Random().nextInt(0xFFFFFF)),
                                );

                                await isar.savedSubjects.put(isarSubject);
                                isarSchedule!.subjects.add(isarSubject);

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
                                setState(() {});
                              });
                            },
                          ),
                          if (MediaQuery.of(context).size.width > 600) ...[
                            IconButton(
                              tooltip: 'Increase text sizes',
                              onPressed: () => increaseTextSize(snapshot),
                              icon: const Icon(Icons.text_increase_rounded),
                            ),
                            IconButton(
                              tooltip: 'Reduce text sizes',
                              onPressed: () => decreaseTextSize(snapshot),
                              icon: const Icon(Icons.text_decrease_rounded),
                            ),
                          ],
                          IconButton(
                              onPressed: () {
                                // open bottomsheet
                                showModalBottomSheet(
                                    context: context,
                                    builder: (_) => SettingBottomSheet(
                                          savedSchedule: snapshot.data,
                                        ));
                              },
                              tooltip: 'Settings',
                              icon: const Icon(Icons.settings_outlined)),
                          PopupMenuButton(
                              itemBuilder: (context) {
                                return <PopupMenuEntry>[
                                  // zoom tezt will show in app bar if screen width is large enough
                                  // otherwise, it will be shown in the popup menu
                                  if (MediaQuery.of(context).size.width <
                                      600) ...[
                                    const PopupMenuItem(
                                      value: 'text+',
                                      child: Text('Text size +'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'text-',
                                      child: Text('Text size -'),
                                    ),
                                    const PopupMenuDivider(),
                                  ],
                                  PopupMenuItem(
                                    value: 'save',
                                    // when changing the item below
                                    // don't forget to also change
                                    // in schedule_layout.dart
                                    child: Text(kIsWeb
                                        ? 'Export'
                                        : Platform.isAndroid
                                            ? 'Export & share'
                                            : 'Export'),
                                  ),
                                  const PopupMenuDivider(),
                                  const PopupMenuItem(
                                      value: 'metadata',
                                      child: Text('Metadata')),
                                  // const PopupMenuItem(
                                  //   // TODO: Implement delete
                                  //   value: 'delete',
                                  //   child: Text('Delete'),
                                  // ),
                                ];
                              },
                              onSelected: popupMenuHandler),
                        ],
                      ),
                body: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      // pull-to-refresh implementation here
                      child: SmartRefresher(
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          child: TimetableViewWidget(
                            startHour: laneEventsList.startHour,
                            endHour: laneEventsList.endHour,
                            laneEventsList: laneEventsList.laneEventsList,
                            itemHeight: snapshot.data!.heightFactor,
                          ))),
                ),
                floatingActionButton: _hideFab
                    ? null
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (snapshot.data!.heightFactor <= 90)
                            FloatingActionButton(
                                heroTag: "btnZoom+",
                                tooltip: "Zoom in (increase height)",
                                mini: true,
                                child: const Icon(Icons.zoom_in),
                                onPressed: () {
                                  setState(
                                      () => snapshot.data!.heightFactor += 2);
                                  isarService.updateSchedule(snapshot.data!);
                                }),
                          if (kIsWeb || !Platform.isAndroid)
                            const SizedBox(height: 5),
                          if (snapshot.data!.heightFactor >= 44)
                            FloatingActionButton(
                                heroTag: "btnZoom-",
                                tooltip: "Zoom out (decrease height)",
                                mini: true,
                                child: const Icon(Icons.zoom_out),
                                onPressed: () {
                                  setState(
                                      () => snapshot.data!.heightFactor -= 2);
                                  isarService.updateSchedule(snapshot.data!);
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
        },
      ),
    );
  }

  void increaseTextSize(AsyncSnapshot snapshot) {
    setState(() {
      snapshot.data!.fontSize++;
      isarService.updateSchedule(snapshot.data!);
    });
  }

  void decreaseTextSize(AsyncSnapshot snapshot) {
    setState(() {
      snapshot.data!.fontSize--;
      isarService.updateSchedule(snapshot.data!);
    });
  }

  void popupMenuHandler(value) async {
    var schedule = await isarService.getSavedSchedule(id: widget.id);
    switch (value) {
      case 'save':
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScheduleExportPage(
                scheduleTitle: schedule!.title!,
                laneEventsResponse: LaneEventsUtil(
                        context: context,
                        fontSize: schedule.fontSize,
                        savedSubjectList: schedule.subjects.toList())
                    .laneEvents(),
                itemHeight: schedule.heightFactor),
          ),
        );
        break;
      case 'metadata':
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => MetadataSheet(
                  savedScheduleId: schedule!.id!,
                ));
        break;
      case 'text+':
        increaseTextSize(
            AsyncSnapshot.withData(ConnectionState.done, schedule));
        break;
      case 'text-':
        decreaseTextSize(
            AsyncSnapshot.withData(ConnectionState.done, schedule));
        break;
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
