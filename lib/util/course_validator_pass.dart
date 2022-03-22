import 'package:albiruni/albiruni.dart';

class CourseValidatorPass {
  final int _length;
  late List<bool> _status;
  late List<Subject?> _subjects;
  CourseValidatorPass(this._length) : super() {
    _status = List.filled(_length, false);
    _subjects = List.filled(_length, null);
  }

  // set which index is failed
  void subjectSuccess(int index, Subject subject) {
    _status[index] = true;
    _subjects[index] = subject;
  }

// Will return true if everything's fine
  bool isClearToProceed() {
    return !_status.contains(false);
  }

// How many item is failed to obtain data
  int countFailedToFetch() {
    return _status.where((element) => !element).length;
  }

  //TODO: Why need map in this situation
  // To cast to List<Subject?>
  List<Subject> fetchedSubjects() => _subjects.map((e) => e!).toList();
}
