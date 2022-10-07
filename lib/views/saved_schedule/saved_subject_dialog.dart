import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../hive_model/saved_subject.dart';
import '../../providers/saved_subjects_provider.dart';
import '../../util/extensions.dart';
import '../course browser/subject_screen.dart';
import 'subject_colour_dialog.dart';

class SavedSubjectDialog extends StatefulWidget {
  const SavedSubjectDialog({
    Key? key,
    required SavedSubject subject,
  })  : _subject = subject,
        super(key: key);

  final SavedSubject _subject;

  @override
  State<SavedSubjectDialog> createState() => _SavedSubjectDialogState();
}

class _SavedSubjectDialogState extends State<SavedSubjectDialog> {
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late Color subjectColour;

  @override
  void initState() {
    super.initState();
    startTime = TimeOfDay(
        hour: int.parse(
            widget._subject.dayTime.first!.startTime.split(":").first),
        minute: int.parse(
            widget._subject.dayTime.first!.startTime.split(":").last));
    endTime = TimeOfDay(
        hour:
            int.parse(widget._subject.dayTime.first!.endTime.split(":").first),
        minute:
            int.parse(widget._subject.dayTime.first!.endTime.split(":").last));

    subjectColour = Color(widget._subject.hexColor!);
  }

  @override
  Widget build(BuildContext context) {
    var actionButtonColour = Theme.of(context).textTheme.bodyLarge!.color;

    var duration = endTime.difference(startTime);
    return Consumer<SavedSubjectsProvider>(
      builder: (context, value, _) {
        return AlertDialog(
          title: Text(widget._subject.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.pin_drop_outlined),
                  title: Text(widget._subject.venue ?? "No venue")),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.schedule_outlined,
                ),
                title: Text(
                    "Starts ${startTime.toRealString()}, ends ${endTime.toRealString()}"),
                subtitle: Text(duration.minute == 0
                    ? 'Duration ${duration.hour}h'
                    : 'Duration ${duration.hour}h ${duration.minute}m'),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.circle,
                    color: value.subjectColour(widget._subject.code)),
                title: const Text("Change colour"),
                onTap: () async {
                  var selectedColour = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SubjectColourDialog(
                        subjectName: widget._subject.code,
                        color: subjectColour,
                      ),
                    ),
                  );

                  if (selectedColour == null) return;

                  value.modifyColour(
                      courseCode: widget._subject.code,
                      newColor: selectedColour);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SubjectScreen(
                                widget._subject.toSubject(),
                                isCached: true,
                              )));
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
      },
    );
  }
}
