import 'dart:async';

import 'package:flutter/material.dart';

mixin TimetableViewController {
  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();
  final _horizontalPixelsStream = StreamController<double>();
  final _verticalPixelsStream = StreamController<double>();

  ScrollController get horizontalScrollController =>
      _horizontalScrollController;
  ScrollController get verticalScrollController => _verticalScrollController;

  StreamController get horizontalPixelsStream => _horizontalPixelsStream;
  StreamController get verticalPixelsStream => _verticalPixelsStream;

  void initController() {
    horizontalScrollController.addListener(horizontalScrollListener);
    verticalScrollController.addListener(verticalScrollListener);
  }

  void disposeController() {
    _horizontalPixelsStream.close();
    _verticalPixelsStream.close();
  }

  void setHorizontal(double num) {
    if (_horizontalScrollController.position.maxScrollExtent >= num) {
      _horizontalScrollController.jumpTo(num);
    }
  }

  void setVertical(double num) {
    if (_verticalScrollController.position.maxScrollExtent >= num) {
      _verticalScrollController.jumpTo(num);
    }
  }

  void horizontalScrollListener() {
    _horizontalPixelsStream.sink.add(
      _horizontalScrollController.position.pixels,
    );
  }

  void verticalScrollListener() {
    _verticalPixelsStream.sink.add(_verticalScrollController.position.pixels);
  }

  void onScroll(val) {
    double dxNam = val.dx;
    if (dxNam < 0) dxNam *= -1;
    setHorizontal(dxNam);

    double dyNam = val.dy;
    if (dyNam < 0) dyNam *= -1;
    setVertical(dyNam);
  }
}
