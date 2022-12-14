import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import '../constants.dart';
import '../isar_models/saved_schedule.dart' as isar_saved_schedule;
import '../isar_models/saved_subject.dart' as isar_saved_subject;
import '../isar_models/saved_daytime.dart' as isar_saved_daytime;
import '../hive_model/saved_schedule.dart' as hive_saved_schedule;

/// Handles migration from Hive to Isar
/// from previous app version
class MigrateHiveToIsar {
  static Future<void> migrate() async {
    final isar = await Isar.open([
      isar_saved_schedule.SavedScheduleSchema,
      isar_saved_subject.SavedSubjectSchema,
      isar_saved_daytime.SavedDaytimeSchema
    ]);
    // Get Hive box
    final hiveBox =
        Hive.box<hive_saved_schedule.SavedSchedule>(kHiveSavedSchedule);
    // Get all schedules from Hive
    final schedules = hiveBox.values.toList();
    print(schedules);
    // Add all schedules to Isar
    for (final schedule in schedules) {
      final isarSchedule = isar_saved_schedule.SavedSchedule(
        session: schedule.session,
        semester: schedule.semester,
        title: schedule.title,
        lastModified: schedule.lastModified,
        dateCreated: schedule.dateCreated,
        fontSize: schedule.fontSize,
        heightFactor: schedule.heightFactor,
        subjectTitleSetting: schedule.subjectTitleSetting,
        // kuliyyah: 'meow',
      );
      await isar.writeTxn(() async {
        await isar.savedSchedules.put(isarSchedule);
      });
      for (final subject in schedule.subjects!) {
        var isarSubject = isar_saved_subject.SavedSubject(
          title: subject.title,
          code: subject.code,
          chr: subject.chr,
          subjectName: subject.subjectName,
          venue: subject.venue,
          hexColor: subject.hexColor,
          sect: subject.sect,
          lect: subject.lect,
          // kuliyyah: 'meow',
        );

        var isarDayTimes = <isar_saved_daytime.SavedDaytime>[];

        await isar.writeTxn(() async {
          await isar.savedSubjects.put(isarSubject);
        });
        isarSchedule.subjects.add(isarSubject);

        await isar.writeTxn(() async {
          isarSchedule.subjects.save();
        });

        for (final dayTime in subject.dayTime) {
          isarDayTimes.add(isar_saved_daytime.SavedDaytime(
            day: dayTime!.day,
            startTime: dayTime.startTime,
            endTime: dayTime.endTime,
          ));
        }

        print(isarDayTimes);

        await isar.writeTxn(() async {
          await isar.savedDaytimes.putAll(isarDayTimes);
          isarSubject.dayTimes.addAll(isarDayTimes);
          await isarSubject.dayTimes.save();
        });
      }
      // isarBox.putAll(schedules as List<isar_saved_schedule.SavedSchedule>);
      // Delete Hive box
      // hiveBox.deleteFromDisk();
    }
  }
}
