import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class IcsGeneratedDialog extends StatelessWidget {
  const IcsGeneratedDialog({super.key, required this.icsSavedPath});

  final String icsSavedPath;

  /// Open Windows file explorer with file selected
  ///
  /// Refer: https://stackoverflow.com/a/13680458/13617136
  void _locateFile() {
    var folderUri = Uri.file(icsSavedPath);
    print(folderUri.toFilePath());
    Process.run('explorer.exe', ['/select,', folderUri.toFilePath()]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectableText('ICS file saved in $icsSavedPath'),
          const SizedBox(height: 20),
          Row(
            children: [
              if (!kIsWeb && Platform.isWindows) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.folder),
                    onPressed: () {
                      _locateFile();
                      Navigator.pop(context);
                    },
                    label: const Text('Locate file'),
                  ),
                ),
                const SizedBox(width: 5),
              ],
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.shareXFiles([XFile(icsSavedPath)],
                        text: 'IIUM exam calendar file');
                    Navigator.pop(context);
                  },
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
