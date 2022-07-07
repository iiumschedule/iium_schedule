import 'package:flutter/material.dart';

class RenameDialog extends StatelessWidget {
  const RenameDialog({
    Key? key,
    required TextEditingController scheduleNameController,
  })  : _scheduleNameController = scheduleNameController,
        super(key: key);

  final TextEditingController _scheduleNameController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rename"),
      content: TextField(controller: _scheduleNameController),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(
          onPressed: () => Navigator.pop(context, _scheduleNameController.text),
          child: const Text("Rename"),
        ),
      ],
    );
  }
}
