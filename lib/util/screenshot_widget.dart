import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'save_file.dart';

class ScreenshotWidget {
  /// Capture the screenshot of the given widget wrapped in RepaintBoundary
  /// and return the path to the saved image
  static Future<String?> screenshot(
      GlobalKey<State<StatefulWidget>> globalKey, String name) async {
    SaveFile sf = SaveFile();
    RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    // In debug mode Android sometimes will return !debugNeedsPrint error
    // TODO: this can be remove?
    if (kDebugMode ? boundary.debugNeedsPaint : false) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
    }
    ui.Image image = await boundary.toImage(pixelRatio: 2);
    // TODO: Saves to gallery

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    // sanitize file name and change space to dash
    final filename =
        name.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '-');

    // return saved path of the image, if web it will return null
    return await sf.save(pngBytes, filename);
  }
}
