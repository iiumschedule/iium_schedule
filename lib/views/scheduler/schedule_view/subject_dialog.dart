import 'package:albiruni/albiruni.dart';
import 'package:flutter/material.dart';

import '../../../util/extensions.dart';
import '../../course browser/subject_screen.dart';

class SubjectDialog extends StatelessWidget {
  const SubjectDialog({
    Key? key,
    required Subject subject,
    required MaterialColor color,
    required TimeOfDay start,
    required TimeOfDay end,
  })  : _subject = subject,
        _color = color,
        _start = start,
        _end = end,
        super(key: key);

  final Subject _subject;
  final MaterialColor _color;
  final TimeOfDay _start;
  final TimeOfDay _end;

  @override
  Widget build(BuildContext context) {
    var actionButtonColour = Theme.of(context).textTheme.bodyLarge!.color;

    var duration = _end.difference(_start);
    return AlertDialog(
      backgroundColor:
          _color[Theme.of(context).brightness == Brightness.light ? 50 : 900],
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
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => SubjectScreen(_subject)));
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
