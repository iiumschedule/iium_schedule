import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:provider/provider.dart';

import '../enums/subject_title_setting_enum.dart';
import '../hive_model/saved_schedule.dart';
import '../hive_model/saved_subject.dart';
import '../providers/schedule_layout_setting_provider.dart';
import '../views/saved_schedule/saved_subject_dialog.dart';
import 'extensions.dart';

class LaneEventsUtil {
  final BuildContext context;
  final SavedSchedule savedSchedule;
  final List<SavedSubject> savedSubjectList;
  int _startHour = 10; // pukul 10 am;
  int _endHour = 17; // pukul 5 pm

  // constructor
  LaneEventsUtil({
    required this.context,
    required this.savedSchedule,
    required this.savedSubjectList,
  });

  LaneEventsResponse laneEvents() {
    List<LaneEvents> laneEventsList = [];
    // var brightness = SchedulerBinding.instance.window.platformBrightness;
    var brightness = Theme.of(context).brightness;
    // Find if there any subject in each day
    for (var i = 1; i <= 7; i++) {
      List<SavedSubject?> extractedSubjects = [];

      // Seperate subject into their day and rebuild the list
      for (var subject in savedSubjectList) {
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
          Color textColor = Color(e.hexColor!).computeLuminance() > 0.5
              ? Colors.black
              : Colors.white;

          return TableEvent(
            textStyle:
                TextStyle(fontSize: savedSchedule.fontSize, color: textColor),
            title: Provider.of<ScheduleLayoutSettingProvider>(context)
                        .subjectTitleSetting ==
                    SubjectTitleSetting.title
                ? e.title
                : e.code,
            backgroundColor: Color(e.hexColor!),
            start: TableEventTime(hour: start.hour, minute: start.minute),
            end: TableEventTime(hour: end.hour, minute: end.minute),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (_) => SavedSubjectDialog(subject: e),
              );
            },
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
