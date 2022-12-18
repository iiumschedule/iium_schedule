import 'package:flutter/widgets.dart';

/// To notify [SavedScheduleLayout] about changes in dialog etc.
class ScheduleNotifierProvider extends ChangeNotifier {
  // just to notify the listeners when something changes
  void notify() {
    notifyListeners();
  }
}
