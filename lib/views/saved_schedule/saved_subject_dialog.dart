import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../isar_models/saved_subject.dart';
import '../../providers/schedule_notifier_provider.dart';
import '../../services/isar_service.dart';
import '../../util/extensions.dart';
import '../course browser/subject_screen.dart';
import 'subject_colour_dialog.dart';

/// TODO: turn this dialog onto a page
class SavedSubjectDialog extends StatefulWidget {
  const SavedSubjectDialog({
    Key? key,
    required this.subjectId,
    required this.dayTimesId,
  }) : super(key: key);

  final int subjectId;
  final int dayTimesId;

  @override
  State<SavedSubjectDialog> createState() => _SavedSubjectDialogState();
}

class _SavedSubjectDialogState extends State<SavedSubjectDialog> {
  final IsarService isarService = IsarService();

  bool isEdtingEnabled = false;
  bool isEditingVenue = false;

  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    var actionButtonColour = Theme.of(context).textTheme.bodyLarge!.color;

    return StreamBuilder<SavedSubject?>(
      stream: isarService.listenToSavedSubject(id: widget.subjectId),
      builder: (context, AsyncSnapshot<SavedSubject?> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AlertDialog(
              content: Padding(
            padding: EdgeInsets.all(100.0),
            child: Text('Loading...'),
          ));
        }
        TextEditingController venueController =
            TextEditingController(text: snapshot.data?.venue ?? "No venue");
        var startTime = TimeOfDay(
            hour: int.parse(
                snapshot.data!.dayTimes.first.startTime.split(":").first),
            minute: int.parse(
                snapshot.data!.dayTimes.first.startTime.split(":").last));
        var endTime = TimeOfDay(
            hour: int.parse(
                snapshot.data!.dayTimes.first.endTime.split(":").first),
            minute: int.parse(
                snapshot.data!.dayTimes.first.endTime.split(":").last));
        var duration = endTime.difference(startTime);

        return AlertDialog(
          title: Text(snapshot.data!.title),
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
                      snapshot.data?.venue ?? "No venue",
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
                            snapshot.data!.venue = venueController.text;

                            isarService.updateSubject(snapshot.data!);
                            Provider.of<ScheduleNotifierProvider>(context,
                                    listen: false)
                                .notify();
                          },
                        ),
                      ),
                    ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.class_outlined),
              title: Text(
                'Section ${snapshot.data!.sect}',
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
                        subjectName: snapshot.data!.code,
                        color: Color(snapshot.data!.hexColor!),
                      ),
                    ),
                  );

                  if (selectedColour == null) return;

                  snapshot.data!.hexColor = selectedColour.value;

                  isarService.updateSubject(snapshot.data!);
                  // notify the schedule behind the dialog to reflect the
                  // new information
                  Provider.of<ScheduleNotifierProvider>(context, listen: false)
                      .notify();

                  setState(() => isEditingVenue = false);
                },
                icon:
                    Icon(Icons.circle, color: Color(snapshot.data!.hexColor!)),
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
                      onPressed: () async {
                        // cannot use dayTimes from snapshot.data!.id because
                        // it contains dayTime for other subject instance as well
                        await isarService.deleteSingleSubject(
                            subjectId: widget.subjectId,
                            dayTimesId: widget.dayTimesId);
                        if (!mounted) return;
                        Navigator.pop(context);
                        Provider.of<ScheduleNotifierProvider>(context,
                                listen: false)
                            .notify();
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
                                snapshot.data!.toSubject(),
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
