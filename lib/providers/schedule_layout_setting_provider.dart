import 'package:flutter/cupertino.dart';

import '../enums/subject_title_setting_enum.dart';
import '../util/lane_events_util.dart';

class ScheduleLayoutSettingProvider extends ChangeNotifier {
  SubjectTitleSetting? _subjectTitleSetting;
  ExtraInfo _extraInfo = ExtraInfo.none;

  SubjectTitleSetting? get subjectTitleSetting => _subjectTitleSetting;

  /// Set the value without call setState() or markNeedsBuild() called during build.
  void initialConditionSubjectTitle(SubjectTitleSetting setting) {
    _subjectTitleSetting = setting;
  }

  set subjectTitleSetting(SubjectTitleSetting? value) {
    _subjectTitleSetting = value;
    notifyListeners();
  }

  ExtraInfo get extraInfo => _extraInfo;

  set extraInfo(ExtraInfo value) {
    _extraInfo = value;
    notifyListeners();
  }
}
