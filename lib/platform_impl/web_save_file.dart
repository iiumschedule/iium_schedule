import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'base_save_file.dart';

class SaveImpl extends BaseSaveFile {
  @override
  Future<String?> save(Uint8List pngBytes, String filename) {
    // https://stackoverflow.com/a/69668841/13617136
    final base64 = base64Encode(pngBytes);
    final anchor =
        AnchorElement(href: 'data:application/octet-stream;base64,$base64')
          ..download = "$filename.png"
          ..target = 'blank';

    document.body!.append(anchor);
    anchor.click();
    anchor.remove();

    return Future.value(null);
  }
}
