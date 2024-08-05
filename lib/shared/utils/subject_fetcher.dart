import 'package:albiruni/albiruni.dart';

class SubjectFetcher {
  static Future<Subject> fetchSubjectData(
      {required Albiruni albiruni,
      required String kulliyyah,
      required String courseCode,
      required int section}) async {
    // loop for every pages to find the subject, most of the time it
    // is in the first page, but for subject it isn't
    for (int i = 1;; i++) {
      var (fetchedSubjects, _) =
          await albiruni.fetch(kulliyyah, page: i, course: courseCode);
      if (fetchedSubjects.isEmpty) break;
      try {
        // try finding the section
        return fetchedSubjects.firstWhere((element) => element.sect == section);
      } catch (e) {
        // catch and ignore the `Bad state: No element` error
        // and continue the loop
        print(e);
      }
    }

    // this function is terminated when error thrown by albiruni
    throw Exception("Subject not found");
  }
}
