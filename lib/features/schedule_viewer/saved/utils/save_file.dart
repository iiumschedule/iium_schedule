import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

class SaveFile {
  /// Save image to device gallery. Permission will be asked
  /// Returns the path of the saved file (if available, null is not indicator of error)
  static Future<void> saveToGallery(Uint8List pngBytes, String filename) async {
    // sanitize file name and change space to dash
    final filenameSanitized =
        filename.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '-');
    String saveDirectory =
        await getTemporaryDirectory().then((value) => value.path);

    File imgFile = File('$saveDirectory/$filenameSanitized.png');
    await imgFile.writeAsBytes(pngBytes);

    // Request access permission.
    // On Android, permission is needed for Android >=23 && <=29 only. Else, it will
    // be allowed by default.
    await Gal.requestAccess(toAlbum: true);

    // the maintainer said using putImage is better than putImageBytes
    // https://github.com/natsuk4ze/gal/wiki/Best-Practice
    try {
      await Gal.putImage(imgFile.path, album: 'IIUM Schedule');
    } on GalException catch (e) {
      throw e.type.message;
    }
  }

  /// Save image to Downloads folder
  /// Returns the path of the saved file
  static Future<String?> saveToDownloads(
      Uint8List pngBytes, String filename) async {
    String? saveDirectory;

    final downloadDirectory = await getDownloadsDirectory();
    final folderDirectory =
        await Directory('${downloadDirectory!.path}/IIUM Schedule').create();

    saveDirectory = folderDirectory.path;

    File imgFile = File('$saveDirectory/$filename.png');
    await imgFile.writeAsBytes(pngBytes);

    return imgFile.path;
  }

  /// Save file in temporary directory
  static Future<String?> saveTemp(Uint8List pngBytes) async {
    String saveDirectory =
        await getTemporaryDirectory().then((value) => value.path);

    // generate random filename
    String filename = DateTime.now().millisecondsSinceEpoch.toString();

    // Save bytes to file
    File imgFile = File('$saveDirectory/$filename.png');
    await imgFile.writeAsBytes(pngBytes);

    return imgFile.path;
  }
}
