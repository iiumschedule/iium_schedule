import 'package:flutter/material.dart';

class ExportToIcsPromptDialog extends StatelessWidget {
  const ExportToIcsPromptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(
          "Exams succesfully added. You can also add the exams to your phone's calendar, such as Google calendar or Apple calendar, to receive reminders and keep track of your schedule easily."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("No. Thanks"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Add to calendar"),
        ),
      ],
    );
  }
}
