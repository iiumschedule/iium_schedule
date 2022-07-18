import 'package:flutter/cupertino.dart';

enum SubjectTitleSetting { title, courseCode }

class ScheduleLayoutSettingProvider extends ChangeNotifier {
  SubjectTitleSetting _subjectTitleSetting = SubjectTitleSetting.title;

  SubjectTitleSetting get subjectTitleSetting => _subjectTitleSetting;

  set subjectTitleSetting(SubjectTitleSetting value) {
    _subjectTitleSetting = value;
    notifyListeners();
  }
}
