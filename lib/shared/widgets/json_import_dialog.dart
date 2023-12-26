import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import '../providers/settings_provider.dart';

class JsonImportDialog extends StatefulWidget {
  const JsonImportDialog({super.key, required this.helpLink});

  final String helpLink;

  @override
  State<JsonImportDialog> createState() => _JsonImportDialogState();
}

class _JsonImportDialogState extends State<JsonImportDialog> {
  final _jsonInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Import JSON',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _jsonInputController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Can\'t add. Data is empty';
                  }
                  try {
                    jsonDecode(value);
                  } on FormatException catch (e) {
                    return 'Failed to decode JSON. (${e.message})';
                  }

                  // check for other value error
                  // this usually when users paste the wrong JSON etc.
                  if (!_validateJson(value)) {
                    return 'Unexpected format. Make sure you are pasting the correct JSON';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'JSON',
                  filled: true,
                  errorMaxLines: 2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 5,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Link(
                uri: Uri.parse(widget.helpLink),
                target: LinkTarget.blank,
                builder: (_, followLink) => TextButton(
                  onPressed: followLink,
                  child: const Text('Learn how to import data from JSON',
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      )),
                ),
              ),
            ),
            if (Provider.of<SettingsProvider>(context).developerMode)
              TextButton(
                  onPressed: () {
                    _jsonInputController.text = '''
[{"courseCode":"CCRN 3152","section":1},{"courseCode":"MANU 4211","section":1},{"courseCode":"MCTE 4314","section":2},{"courseCode":"MCTE 4327","section":1},{"courseCode":"MCTE 4334","section":2},{"courseCode":"MCTE 4362","section":1},{"courseCode":"MCTE 4399","section":1}]
''';
                  },
                  child: const Text('Paste sample JSON*')),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (!_formKey.currentState!.validate()) return;

                    List<dynamic> decodedJson =
                        jsonDecode(_jsonInputController.text);

                    Navigator.of(context).pop(decodedJson);
                  },
                  child: const Text('Import'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Validate JSON so that only format like this
/// https://iiumschedule.iqfareez.com/docs/extract/imaluum/#4-finish will be accepted
///
/// Return [true] if valid, [false] otherwise
bool _validateJson(String jsonString) {
  final courses = jsonDecode(jsonString);

  // check if the json is list. Eg: [{...}, {...}]
  if (courses is! List<dynamic>) {
    return false;
  }

  if (courses.isEmpty) return false;

  for (var course in courses) {
    if (course == null || course is! Map) return false;
    if (!course.containsKey("courseCode") || !course.containsKey("section")) {
      return false;
    }
    if (course["courseCode"] == null || course["courseCode"] is! String) {
      return false;
    }
    if (course["section"] == null || course["section"] is! int) {
      return false;
    }
  }

  return true;
}
