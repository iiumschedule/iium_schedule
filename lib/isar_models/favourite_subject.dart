import 'package:isar_community/isar.dart';

part 'favourite_subject.g.dart';

/// This class only store the basic information of a subject
/// ie not including the title, lecturer, etc
///
/// The basic information is used to fetch the subject from albiruni
///
///  Cannot extends from Subject class, due to it have incompatible type
/// So I had to reintroduce the parameters here

@collection
class FavouriteSubject {
  Id? id;

  String kulliyyahCode;

  String session;

  int semester;

  String courseCode;

  int section;

  DateTime favouritedDate;

  FavouriteSubject({
    required this.kulliyyahCode,
    required this.semester,
    required this.session,
    required this.courseCode,
    required this.section,
    required this.favouritedDate,
  });
}
