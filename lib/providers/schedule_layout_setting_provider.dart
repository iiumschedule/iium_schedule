import 'package:flutter/cupertino.dart';

import '../enums/subject_title_setting_enum.dart';

class ScheduleLayoutSettingProvider extends ChangeNotifier {
  SubjectTitleSetting? _subjectTitleSetting;

  SubjectTitleSetting? get subjectTitleSetting => _subjectTitleSetting;

  void initialConditionSubjectTitle(SubjectTitleSetting setting) {
    _subjectTitleSetting = setting;
  }

  set subjectTitleSetting(SubjectTitleSetting? value) {
    _subjectTitleSetting = value;
    notifyListeners();
  }
}
