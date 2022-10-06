import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'base_save_file.dart';

/// Implementation for Android and Windows

class SaveImpl extends BaseSaveFile {
  @override
  Future<String?> save(
      Uint8List pngBytes, String filename, bool tempPath) async {
    String? saveDirectory;
    if (tempPath) {
      saveDirectory = await getTemporaryDirectory().then((value) => value.path);
    } else {
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (status.isDenied) throw Exception('Permission denied');

        // create/use Picture folder

        final folderDirectory =
            await Directory('/storage/emulated/0/Pictures/IIUM Schedule')
                .create();
        saveDirectory = folderDirectory.path;
      }

      if (Platform.isWindows) {
        final downloadDirectory = await getDownloadsDirectory();
        // use download folder
        final folderDirectory =
            await Directory('${downloadDirectory!.path}/IIUM Schedule')
                .create();

        saveDirectory = folderDirectory.path;
      }
    }

    File imgFile = File('$saveDirectory/$filename.png');
    imgFile.writeAsBytes(pngBytes);

    return imgFile.path;
  }
}
