import 'dart:typed_data';

abstract class BaseSaveFile {
  Future<String?> save(Uint8List pngBytes, String filename);
}
