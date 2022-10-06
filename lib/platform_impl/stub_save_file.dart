import 'dart:typed_data';

import 'base_save_file.dart';

class SaveImpl extends BaseSaveFile {
  @override
  Future<String?> save(Uint8List pngBytes, String filename, bool tempPath) {
    throw UnimplementedError();
  }
}
