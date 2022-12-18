import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:provider/provider.dart';

import '../enums/subject_title_setting_enum.dart';
import '../isar_models/saved_subject.dart';
import '../isar_models/saved_daytime.dart';
import '../providers/schedule_layout_setting_provider.dart';
import '../views/saved_schedule/saved_subject_dialog.dart';
import 'extensions.dart';

// Perhaps this will no longer neede when Dart's new Records are landed
class LaneEventsUtil {
  final BuildContext context;
  final List<SavedSubject> savedSubjectList;
  final double fontSize;
  int _startHour = 10; // pukul 10 am;
  int _endHour = 17; // pukul 5 pm

  // constructor
  LaneEventsUtil({
    required this.context,
    required this.savedSubjectList,
    required this.fontSize,
  });

  LaneEventsResponse laneEvents() {
    List<LaneEvents> laneEventsList = [];
    // var brightness = SchedulerBinding.instance.window.platformBrightness;
    var brightness = Theme.of(context).brightness;
    // Find if there any subject in each day
    for (var i = 1; i <= 7; i++) {
      List<SubjectEvents?> subjectEvents = [];

      // Seperate subject into their day and rebuild the list
      for (var subject in savedSubjectList) {
        var dayTimes = subject.dayTimes.where((element) => element.day == i);

        subjectEvents.addAll(
          dayTimes.map((e) {
            return SubjectEvents(
              subjectId: subject.id!,
              dayTimes: [e],
              title: subject.title,
              code: subject.code,
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

          if (end.hour > _endHour) _endHour = end.hour;

          // saved colour  - compute luminance & bg colour
          Color textColor =
              e.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

          return TableEvent(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              color: Color(e.hexColor!)
            ),
            textStyle: TextStyle(fontSize: fontSize, color: textColor),
            title: Provider.of<ScheduleLayoutSettingProvider>(context)
                        .subjectTitleSetting ==
                    SubjectTitleSetting.title
                ? e.title
                : e.code,
            backgroundColor: e.color,
            start: TableEventTime(hour: start.hour, minute: start.minute),
            end: TableEventTime(hour: end.hour, minute: end.minute),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (_) => SavedSubjectDialog(
                  subjectId: e.subjectId,
                  dayTimesId: e.dayTimes.first.id!,
                ),
              );

              // clean up residue if any
              // Provider.of<SavedSubjectsProvider>(context, listen: false)
              //     .cleanUpResidue();
            },
          );
        },
      );
      Lane lane = Lane(
        backgroundColor: Theme.of(context).colorScheme.background,
        name: i.englishDay().substring(0, 3).toUpperCase(),
        textStyle: TextStyle(
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
    return LaneEventsResponse(
        laneEventsList: laneEventsList,
        startHour: _startHour,
        endHour: _endHour);
  }

  // int get scheduleStartHour => _startHour;
  // int get scheduleEndHour => _endHour;
}

class LaneEventsResponse {
  final List<LaneEvents> laneEventsList;
  final int startHour;
  final int endHour;

  LaneEventsResponse({
    required this.laneEventsList,
    required this.startHour,
    required this.endHour,
  });
}

class SubjectEvents {
  final String title;
  final String code;
  final Color color;
  final int subjectId;
  final List<SavedDaytime> dayTimes;

  SubjectEvents({
    required this.subjectId,
    required this.dayTimes,
    required this.title,
    required this.code,
    required this.color,
  });
}
