import 'dart:typed_data';

import '../../../../platform_impl/not_web_save_file.dart'
    if (dart.library.io) '../../../../platform_impl/not_web_save_file.dart'
    if (dart.library.html) '../../../../platform_impl/web_save_file.dart';

class SaveFile {
  final SaveImpl _saveImpl;

  SaveFile() : _saveImpl = SaveImpl();

  Future<String?> save(
      Uint8List pngBytes, String filename, bool tempPath) async {
    return _saveImpl.save(pngBytes, filename, tempPath);
  }
}
