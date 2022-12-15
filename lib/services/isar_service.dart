import 'package:isar/isar.dart';

import '../isar_models/saved_daytime.dart';
import '../isar_models/saved_schedule.dart';
import '../isar_models/saved_subject.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  // Future<void> saveCat(Cat newCat) async {
  //   final isar = await db;
  //   isar.writeTxnSync<int>(() => isar.cats.putSync(newCat));
  // }

  // Future<List<Cat>> getAllCat() async {
  //   final isar = await db;
  //   return await isar.cats.where().findAll();
  // }

  // Stream<List<Cat>> listenToCat() async* {
  //   final isar = await db;
  //   yield* isar.cats.where().watch(fireImmediately: true);
  // }

  // Stream<Cat?> listenToSingleCat(int id) async* {
  //   final isar = await db;
  //   yield* isar.cats.watchObject(id, fireImmediately: true);
  // }

  Stream<SavedSchedule?> listenToSavedSchedule({required int id}) async* {
    final isar = await db;

    yield* isar.savedSchedules.watchObject(id, fireImmediately: true);
  }

  Future<SavedSchedule?> getSavedSchedule({required int id}) async {
    final isar = await db;

    return isar.savedSchedules.get(id);
  }

  Stream<SavedSubject?> listenToSavedSubject({required int id}) async* {
    final isar = await db;

    yield* isar.savedSubjects.watchObject(id, fireImmediately: true);
  }

  Future<void> updateSchedule(SavedSchedule schedule) async {
    final isar = await db;
    isar.writeTxnSync(() {
      isar.savedSchedules.putSync(schedule);
    });
  }

  Future<void> updateSubject(SavedSubject subject) async {
    final isar = await db;
    isar.writeTxnSync(() {
      isar.savedSubjects.putSync(subject);
    });
  }

  // TODO: Add option to delete multiple subject instances at once

  Future<void> deleteSingleSubject(
      {required int subjectId, required int dayTimesId}) async {
    final isar = await db;
    isar.writeTxnSync(() {
      isar.savedDaytimes.deleteSync(dayTimesId);
    });
    // check if the subject has no more dayTimes
    final subject = isar.savedSubjects.getSync(subjectId);
    if (subject!.dayTimes.isEmpty) {
      isar.writeTxnSync(() {
        isar.savedSubjects.deleteSync(subjectId);
      });
    }
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [SavedScheduleSchema, SavedSubjectSchema, SavedDaytimeSchema],
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
