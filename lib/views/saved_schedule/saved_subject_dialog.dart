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
  late TextEditingController venueController;
  late TimeOfDay startTime;
  late TimeOfDay endTime;

  bool isEdtingEnabled = false;
  bool isEditingVenue = false;

  bool isDeleting = false;

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

    venueController = TextEditingController(text: widget._subject.venue);
  }

  @override
  Widget build(BuildContext context) {
    var actionButtonColour = Theme.of(context).textTheme.bodyLarge!.color;

    var duration = endTime.difference(startTime);
    return Consumer<SavedSubjectsProvider>(
      builder: (context, value, _) {
        return AlertDialog(
          title: Text(widget._subject.title),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.pin_drop_outlined),
              onTap: !isEdtingEnabled
                  ? null
                  : () {
                      setState(() {
                        isEditingVenue = true;
                      });
                    },
              title: !isEditingVenue
                  ? Text(
                      value.getVenue(widget._subject.code) ?? "No venue",
                      style: !isEdtingEnabled
                          ? null
                          : const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              decorationStyle: TextDecorationStyle.dotted),
                    )
                  : TextField(
                      controller: venueController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            value.setVenue(
                                courseCode: widget._subject,
                                newVenue: venueController.text);
                            setState(() {
                              isEditingVenue = false;
                            });
                          },
                        ),
                      ),
                    ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.schedule_outlined,
              ),
              title: Text.rich(
                TextSpan(children: [
                  const TextSpan(text: "Starts "),
                  TextSpan(
                    text: startTime.toRealString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const TextSpan(text: ", ends "),
                  TextSpan(
                    text: endTime.toRealString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ]),
              ),
              // "Starts ${startTime.toRealString()}, ends ${endTime.toRealString()}"),
              subtitle: Text(duration.minute == 0
                  ? 'Duration ${duration.hour}h'
                  : 'Duration ${duration.hour}h ${duration.minute}m'),
            ),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              IconButton(
                tooltip: "Change colour",
                onPressed: () async {
                  var selectedColour = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SubjectColourDialog(
                        subjectName: widget._subject.code,
                        color: value.subjectColour(widget._subject.code),
                      ),
                    ),
                  );

                  if (selectedColour == null) return;

                  value.modifyColour(
                      courseCode: widget._subject.code,
                      newColor: selectedColour);
                },
                icon: Icon(Icons.circle,
                    color: value.subjectColour(widget._subject.code)),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: OutlinedButton.icon(
                    label: Text(isEdtingEnabled ? "Done" : "Edit"),
                    onPressed: () {
                      setState(() {
                        isEdtingEnabled = !isEdtingEnabled;
                        isEditingVenue = false;
                      });
                    },
                    icon: Icon(!isEdtingEnabled ? Icons.edit : Icons.edit_off)),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Tooltip(
                  message: "Remove this item",
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => isDeleting = true);
                    },
                    child: const Icon(Icons.delete_forever_outlined),
                  ),
                ),
              ),
            ]),
            // Delete confirmation
            if (isDeleting)
              Row(
                children: [
                  const Text("Confirm delete?"),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        value.deleteSingle(widget._subject);
                        Navigator.pop(context);
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        setState(() => isDeleting = false);
                      },
                      child: const Text('Cancel'))
                ],
              )
          ]),
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
