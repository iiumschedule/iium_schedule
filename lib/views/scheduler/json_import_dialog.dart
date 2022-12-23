import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class JsonImportDialog extends StatefulWidget {
  const JsonImportDialog({super.key});

  @override
  State<JsonImportDialog> createState() => _JsonImportDialogState();
}

class _JsonImportDialogState extends State<JsonImportDialog> {
  final _jsonInputController = TextEditingController();

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
            TextField(
              controller: _jsonInputController,
              decoration: InputDecoration(
                labelText: 'JSON',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Link(
                uri:
                    Uri.parse("https://iiumschedule.iqfareez.com/docs/extract"),
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
                    if (_jsonInputController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Can\'t add. Data is empty'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }
                    List<dynamic> decodedJson;

                    try {
                      decodedJson = jsonDecode(_jsonInputController.text);
                    } on FormatException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to decode JSON (${e.message})'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ));
                      return;
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Failed to decode JSON'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ));
                      return;
                    }
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
