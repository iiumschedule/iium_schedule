import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:provider/provider.dart';

import '../isar_models/saved_schedule.dart';
import '../isar_models/saved_subject.dart';
import '../isar_models/saved_daytime.dart';
import '../providers/schedule_layout_setting_provider.dart';
import '../views/saved_schedule/saved_subject_page.dart';
import 'extensions.dart';

// TODO: This implementation need serious refactoring. Duplicate of this implementation
// is also found in `schedule_layout.dart`.

/// Extra info to replace the time in the event
/// none = default
enum ExtraInfo { venue, section, none }

class LaneEventsUtil {
  final BuildContext context;
  final List<SavedSubject> savedSubjectList;
  final double fontSize;
  final bool highlightCurrentDay;
  int _startHour = 10; // pukul 10 am;
  int _endHour = 17; // pukul 5 pm

  // constructor
  LaneEventsUtil({
    required this.context,
    required this.savedSubjectList,
    required this.fontSize,
    this.highlightCurrentDay = false,
  });

  ({List<LaneEvents> laneEvents, int startHour, int endHour}) laneEvents() {
    final settingProvider =
        Provider.of<ScheduleLayoutSettingProvider>(context, listen: false);
    List<LaneEvents> laneEventsList = [];
    // Find if there any subject in each day
    for (var i = 1; i <= 7; i++) {
      List<SubjectEvents?> subjectEvents = [];

      // Seperate subject into their day and rebuild the list
      for (var subject in savedSubjectList) {
        var dayTimes = subject.dayTimes.where((element) => element.day == i);

        String? extra;

        switch (settingProvider.extraInfo) {
          case ExtraInfo.section:
            extra = 'Sect. ${subject.sect}';
            break;
          case ExtraInfo.venue:
            extra = subject.venue ?? '-';
            break;
          case ExtraInfo.none:
            extra = null;
            break;
        }

        subjectEvents.addAll(
          dayTimes.map((e) {
            return SubjectEvents(
              subjectId: subject.id!,
              dayTimes: [e],
              title: subject.title,
              code: subject.code,
              extras: extra,
              color: Color(subject.hexColor!),
            );
          }),
        );
      }

      var tableEvents = subjectEvents.map(
        (e) {
          var start = TimeOfDay(
              hour: int.parse(e!.dayTimes.first.startTime.split(":").first),
              minute: int.parse(e.dayTimes.first.startTime.split(":").last));
          var end = TimeOfDay(
              hour: int.parse(e.dayTimes.first.endTime.split(":").first),
              minute: int.parse(e.dayTimes.first.endTime.split(":").last));

          if (start.hour < _startHour) _startHour = start.hour;

          if (end.hour > _endHour) _endHour = end.hour + 1;

          // saved colour  - compute luminance & bg colour
          Color textColor =
              e.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

          return TableEvent(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                color: e.color),
            textStyle: TextStyle(fontSize: fontSize, color: textColor),
            title:
                settingProvider.subjectTitleSetting == SubjectTitleSetting.title
                    ? e.title
                    : e.code,
            backgroundColor: e.color,
            start: TableEventTime(hour: start.hour, minute: start.minute),
            end: TableEventTime(hour: end.hour, minute: end.minute),
            heroTag:
                '${e.subjectId}-${e.dayTimes.first.id}', // unique tag to differentiate between subjects
            subtitle:
                settingProvider.extraInfo != ExtraInfo.none ? e.extras : null,
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) {
                return SavedSubjectPage(
                  title: e.title,
                  subjectColor: e.color,
                  subjectId: e.subjectId,
                  dayTimesId: e.dayTimes.first.id!,
                );
              }));
              // await showDialog(
              //   context: context,
              //   builder: (_) => SavedSubjectDialog(
              //     subjectId: e.subjectId,
              //     dayTimesId: e.dayTimes.first.id!,
              //   ),
              // );

              // clean up residue if any
              // Provider.of<SavedSubjectsProvider>(context, listen: false)
              //     .cleanUpResidue();
            },
          );
        },
      );

      // check if lane day is the same day as current day
      // if true, the lane day will be highlighted
      // if [highlightCurrentDay] is true, the isToday will be always false
      final highlightLaneDay =
          highlightCurrentDay && DateTime.now().weekday == i;

      Lane lane = Lane(
        backgroundColor: highlightLaneDay
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.background,
        name: i.englishDay().substring(0, 3).toUpperCase(),
        textStyle: TextStyle(
          color: highlightLaneDay
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onBackground,
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

    return (
      laneEvents: laneEventsList,
      startHour: _startHour,
      endHour: _endHour
    );
  }

  // int get scheduleStartHour => _startHour;
  // int get scheduleEndHour => _endHour;
}

class SubjectEvents {
  final String title;
  final String code;
  final Color color;
  final int subjectId;
  final List<SavedDaytime> dayTimes;

  /// Extra info eg venue, section etc. Used in `subtitle` in the `TableEvent`.
  final String? extras;

  SubjectEvents({
    required this.subjectId,
    required this.dayTimes,
    required this.title,
    required this.code,
    required this.color,
    this.extras,
  });
}
