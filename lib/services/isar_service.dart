import 'package:albiruni/albiruni.dart';
import 'package:isar/isar.dart';

import '../isar_models/favourite_subject.dart';
import '../isar_models/gh_responses.dart';
import '../isar_models/saved_daytime.dart';
import '../isar_models/saved_schedule.dart';
import '../isar_models/saved_subject.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  // TODO: Make function for save new schedule
  // for save new schedule, view [ScheduleLayout]'s save() function

  // TODO: Make function for save & add new subject to a schedule
  // for save new subject, view [SavedScheduleLayout] in manual add subject

  List<SavedSchedule> getAllSchedule() {
    final isar = Isar.getInstance()!;
    return isar.collection<SavedSchedule>().where().findAllSync();
  }

  Future<void> addNewSubject(
      {required int scheduleId,
      required SavedSubject newSubject,
      required SavedDaytime newDayTime}) async {
    final isar = await db;
    isar.writeTxnSync(() {
      isar.savedSubjects.putSync(newSubject);
      isar.savedDaytimes.putSync(newDayTime);
    });

    var currentSchedule = isar.savedSchedules.getSync(scheduleId);

    // add links
    isar.writeTxnSync(() {
      currentSchedule!.subjects.add(newSubject);
      newSubject.dayTimes.add(newDayTime);
      currentSchedule.subjects.save();
      newSubject.dayTimes.save();
    });
  }

  Stream<void> listenToAllSchedulesChanges() async* {
    final isar = await db;

    yield* isar.savedSchedules.watchLazy();
  }

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
    schedule.lastModified = DateTime.now().toString();
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

  Future<void> deleteSchedule(int id) async {
    final isar = await db;
    isar.writeTxnSync(() {
      // delete all linked references
      for (var subject in isar.savedSchedules.getSync(id)!.subjects) {
        for (var dayTime in subject.dayTimes) {
          isar.savedDaytimes.deleteSync(dayTime.id!);
        }
        isar.savedSubjects.deleteSync(subject.id!);
      }
      // finally, delete the schedule reference
      isar.savedSchedules.deleteSync(id);
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
    // if empty, delete the subject object altogether
    if (subject!.dayTimes.isEmpty) {
      isar.writeTxnSync(() {
        isar.savedSubjects.deleteSync(subjectId);
      });
    }
  }

  /// Add new Favourites subject
  Future<void> addFavouritesSubject(
      Albiruni albiruni, String kuliyyah, Subject subject) async {
    final isar = await db;
    var favSubject = FavouriteSubject(
        kulliyyahCode: kuliyyah,
        semester: albiruni.semester,
        session: albiruni.session,
        courseCode: subject.code,
        section: subject.sect,
        favouritedDate: DateTime.now());
    isar.writeTxnSync(() {
      isar.favouriteSubjects.putSync(favSubject);
    });
  }

  /// Check if the subject given subject and scope is already favourited or not
  ///
  /// Return integer is already favourited, null if not
  Future<int?> checkFavourite(
      Albiruni albiruni, String kuliyyah, Subject subject) async {
    final isar = await db;

    var res = await isar.favouriteSubjects
        .filter()
        .courseCodeMatches(subject.code)
        .and()
        .sectionEqualTo(subject.sect)
        .and()
        .kulliyyahCodeMatches(kuliyyah)
        .and()
        .semesterEqualTo(albiruni.semester)
        .and()
        .sessionMatches(albiruni.session)
        .findAll();

    return res.isEmpty ? null : res.first.id;
  }

  /// Get all favourited subjects
  Future<List<FavouriteSubject>> getAllFavourites() async {
    final isar = await db;
    return isar.favouriteSubjects.where().findAll();
  }

  /// Remove a favourited subject, pass the ID of the [FavouriteSubject] object
  Future<void> removeFavouritesSubject(int id) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.favouriteSubjects.delete(id);
    });
  }

  /// Save the [GhResponses] object to the database
  Future<void> addGhResponse(GhResponses response) async {
    final isar = await db;

    isar.writeTxn(() {
      return isar.ghResponses.put(response);
    });
  }

  /// Retrieve the [GhResponses] object from the database
  Future<GhResponses?> getGhResponse() async {
    final isar = await db;

    return isar.ghResponses.get(0);
  }

  // Future<void> cleanDb() async {
  //   final isar = await db;
  //   await isar.writeTxn(() => isar.clear());
  // }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [
          SavedScheduleSchema,
          SavedSubjectSchema,
          SavedDaytimeSchema,
          GhResponsesSchema,
          FavouriteSubjectSchema,
        ],
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
