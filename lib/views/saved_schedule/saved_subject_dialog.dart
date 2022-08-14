import 'package:flutter/material.dart';

import '../../hive_model/saved_subject.dart';
import '../../util/extensions.dart';
import '../course browser/subject_screen.dart';

class SavedSubjectDialog extends StatelessWidget {
  const SavedSubjectDialog({
    Key? key,
    required SavedSubject subject,
    required Color color,
    required TimeOfDay start,
    required TimeOfDay end,
  })  : _subject = subject,
        _color = color,
        _start = start,
        _end = end,
        super(key: key);

  final SavedSubject _subject;
  final Color _color;
  final TimeOfDay _start;
  final TimeOfDay _end;

  @override
  Widget build(BuildContext context) {
    var actionButtonColour = Theme.of(context).textTheme.bodyLarge!.color;

    var duration = _end.difference(_start);
    return AlertDialog(
      title: Text(_subject.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.pin_drop_outlined),
              title: Text(_subject.venue ?? "No venue")),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.schedule_outlined,
            ),
            title: Text(
                "Starts ${_start.toRealString()}, ends ${_end.toRealString()}"),
            subtitle: Text(duration.minute == 0
                ? 'Duration ${duration.hour}h'
                : 'Duration ${duration.hour}h ${duration.minute}m'),
          ),
          const Divider(),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SubjectScreen(_subject.toSubject())));
            },
            child: Text(
              'View details',
              style: TextStyle(color: actionButtonColour),
            )),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: TextStyle(color: actionButtonColour),
            ))
      ],
    );
  }
}
