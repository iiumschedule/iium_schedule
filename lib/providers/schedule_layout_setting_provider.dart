import 'package:flutter/cupertino.dart';

import '../enums/subject_title_setting_enum.dart';

class ScheduleLayoutSettingProvider extends ChangeNotifier {
  SubjectTitleSetting? _subjectTitleSetting;

  SubjectTitleSetting? get subjectTitleSetting => _subjectTitleSetting;

  /// Set the value without call setState() or markNeedsBuild() called during build.
  void initialConditionSubjectTitle(SubjectTitleSetting setting) {
    _subjectTitleSetting = setting;
  }

  set subjectTitleSetting(SubjectTitleSetting? value) {
    _subjectTitleSetting = value;
    notifyListeners();
  }
}
