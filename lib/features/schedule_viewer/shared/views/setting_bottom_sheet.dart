import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../isar_models/saved_schedule.dart';
import '../../../../shared/providers/schedule_layout_setting_provider.dart';
import '../../../../shared/services/isar_service.dart';
import '../../saved/utils/lane_events_util.dart';

/// Pass `savedSchedule` for saved schedule layout only
/// For save to the isar object
class SettingBottomSheet extends StatelessWidget {
  const SettingBottomSheet({super.key, this.savedSchedule});

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
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              Text(
                "Subject title",
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
              const SizedBox(height: 10),
              CupertinoSegmentedControl<SubjectTitleSetting>(
                padding: EdgeInsets.zero,
                groupValue: value.subjectTitleSetting,
                onValueChanged: (SubjectTitleSetting newValue) async {
                  value.subjectTitleSetting = newValue;

                  // for schedule that was already saved, update its data
                  if (savedSchedule == null) return;
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
              const SizedBox(height: 15),
              Text(
                "Subject subtitle",
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
              const SizedBox(height: 10),
              CupertinoSegmentedControl<ExtraInfo>(
                padding: EdgeInsets.zero,
                groupValue: value.extraInfo,
                onValueChanged: (ExtraInfo newValue) async {
                  value.extraInfo = newValue;

                  if (savedSchedule == null) return;
                  savedSchedule?.extraInfo = newValue;
                  isarService.updateSchedule(savedSchedule!);
                },
                children: const <ExtraInfo, Widget>{
                  ExtraInfo.none: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Default'),
                  ),
                  ExtraInfo.section: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Section'),
                  ),
                  ExtraInfo.venue: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Venue'),
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
