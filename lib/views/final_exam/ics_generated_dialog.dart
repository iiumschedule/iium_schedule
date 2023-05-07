import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class IcsGeneratedDialog extends StatelessWidget {
  const IcsGeneratedDialog({super.key, required this.icsSavedFile});

  final File icsSavedFile;

  /// Open Windows file explorer with file selected
  ///
  /// Refer: https://stackoverflow.com/a/13680458/13617136
  void _locateFile() {
    var folderUri = Uri.file(icsSavedFile.path);
    Process.run('explorer.exe', ['/select,', folderUri.toFilePath()]);
  }

  void _openFile() async {
    if (kIsWeb) {
      throw 'Unspported platform';
    }

    if (Platform.isWindows) {
      var fileUri = Uri.file(icsSavedFile.path);
      var res = await canLaunchUrl(fileUri);

      if (!res) throw 'Cannot open file';
      launchUrl(fileUri);
      return;
    }

    // on Android:
    OpenFile.open(icsSavedFile.path, type: 'text/calendar');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'You can open the file to add the exams to your calendar app, or share it with your friends so they can add to their calendars too.',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Container(
            // height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectionArea(
              child: ListTile(
                title: Text(icsSavedFile.path.split('/').last),
                subtitle: !kIsWeb && Platform.isWindows
                    ? Text(Uri.file(icsSavedFile.path).toFilePath())
                    : const Text('ICalendar file'),
                trailing: Tooltip(
                  message: 'Import events to calendar',
                  child: ElevatedButton(
                    onPressed: () {
                      _openFile();
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.open_in_new),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!kIsWeb && Platform.isWindows)
                ElevatedButton.icon(
                  icon: const Icon(Icons.folder),
                  onPressed: () {
                    _locateFile();
                    Navigator.pop(context);
                  },
                  label: const Text('Locate file'),
                ),
              if (!kIsWeb && Platform.isAndroid)
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.shareXFiles([XFile(icsSavedFile.path)],
                        text: 'IIUM exam calendar file');
                    Navigator.pop(context);
                  },
                  label: const Text('Share'),
                ),
              if (kIsWeb)
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    // TODO: Web implement download
                    Navigator.pop(context);
                  },
                  label: const Text('Download'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
