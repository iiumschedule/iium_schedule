import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/schedule_layout_setting_provider.dart';

class SettingBottomSheet extends StatelessWidget {
  const SettingBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (_) => Consumer<ScheduleLayoutSettingProvider>(
        builder: (_, value, __) => Padding(
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
              RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  value: SubjectTitleSetting.title,
                  title: const Text('Show title'),
                  groupValue: value.subjectTitleSetting,
                  onChanged: (SubjectTitleSetting? newValue) {
                    value.subjectTitleSetting = newValue!;
                  }),
              RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  value: SubjectTitleSetting.courseCode,
                  title: const Text('Show course code'),
                  groupValue: value.subjectTitleSetting,
                  onChanged: (SubjectTitleSetting? newValue) {
                    value.subjectTitleSetting = newValue!;
                  }),
            ],
          ),
        ),
      ),
      onClosing: () {},
    );
  }
}
