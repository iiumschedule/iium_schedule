import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScreenshotWidget {
  /// Capture the screenshot of the given widget wrapped in RepaintBoundary
  /// and return the image bytes
  static Future<Uint8List?> screenshotWidget(
      GlobalKey<State<StatefulWidget>> globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    // In debug mode Android sometimes will return !debugNeedsPrint error
    // TODO: this can be remove?
    if (kDebugMode && boundary.debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
    }
    ui.Image image = await boundary.toImage(pixelRatio: 2.5);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }
}
