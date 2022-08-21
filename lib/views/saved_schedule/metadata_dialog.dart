import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../hive_model/saved_schedule.dart';
import '../../widgets/my_bottom_sheet.dart';

class MetadataSheet extends StatelessWidget {
  const MetadataSheet({Key? key, required this.savedSchedule})
      : super(key: key);

  final SavedSchedule savedSchedule;

  @override
  Widget build(BuildContext context) {
    DateTime lastModifiedDate = DateTime.parse(savedSchedule.lastModified);
    DateTime createdDate = DateTime.parse(savedSchedule.dateCreated);
    return MyBottomSheet(
      title: 'Metadata',
      content: [
        ListTile(
          leading: const _LeadingTextWidget('Subject count:'),
          title: Text(savedSchedule.subjects!.length.toString()),
        ),
        ListTile(
          leading: const _LeadingTextWidget('Last modified:'),
          title: Text(DateFormat('d/M/yy').format(lastModifiedDate)),
          subtitle: Text(
              '${DateFormat('hh:mm:ss').format(lastModifiedDate)} (${DateFormat('EEEE').format(lastModifiedDate)})'),
        ),
        ListTile(
          leading: const _LeadingTextWidget('Created on:'),
          title: Text(DateFormat('d/M/yy').format(createdDate)),
          subtitle: Text(
              '${DateFormat('hh:mm:ss').format(createdDate)} (${DateFormat('EEEE').format(createdDate)})'),
        ),
      ],
    );
  }
}

class _LeadingTextWidget extends StatelessWidget {
  const _LeadingTextWidget(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(text)],
    );
  }
}
