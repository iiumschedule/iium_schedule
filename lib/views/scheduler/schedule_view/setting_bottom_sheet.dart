import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../enums/subject_title_setting_enum.dart';
import '../../../isar_models/saved_schedule.dart';
import '../../../providers/schedule_layout_setting_provider.dart';
import '../../../services/isar_service.dart';

/// Pass `savedSchedule` for saved schedule layout only
/// For save to the hive object
class SettingBottomSheet extends StatelessWidget {
  const SettingBottomSheet({Key? key, this.savedSchedule}) : super(key: key);

  final SavedSchedule? savedSchedule;

  @override
  Widget build(BuildContext context) {
    final IsarService isarService = IsarService();
    return Consumer<ScheduleLayoutSettingProvider>(
      builder: (_, value, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Customize your schedule',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 15),
              Text(
                "Subject display",
                style: Theme.of(context).textTheme.bodyText1!,
              ),
              const SizedBox(height: 10),
              CupertinoSegmentedControl<SubjectTitleSetting>(
                padding: EdgeInsets.zero,
                groupValue: value.subjectTitleSetting,
                onValueChanged: (SubjectTitleSetting newValue) async {
                  value.subjectTitleSetting = newValue;

                  // save to hive for saved schedule layout
                  savedSchedule?.subjectTitleSetting = newValue;

                  isarService.updateSchedule(savedSchedule!);
                },
                children: const <SubjectTitleSetting, Widget>{
                  SubjectTitleSetting.title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Course name'),
                  ),
                  SubjectTitleSetting.courseCode: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Course code'),
                  ),
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
