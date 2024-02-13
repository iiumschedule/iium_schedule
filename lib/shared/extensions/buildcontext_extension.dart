import 'package:flutter/widgets.dart';

extension Utility on BuildContext {
  /// Move to next text field
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (FocusScope.of(this).focusedChild!.context == null);
  }
}
