import 'package:flutter/material.dart';

/// Taken and modified from StepPageIndicator class
/// Display title and the indicator dots based on the current page
class AppbarTitle extends StatefulWidget {
  /// The current page index ValueNotifier
  final ValueNotifier<int> currentPageNotifier;

  /// The number of items managed by the PageController
  final int itemCount;

  const AppbarTitle({
    super.key,
    required this.currentPageNotifier,
    required this.itemCount,
  });

  @override
  State<AppbarTitle> createState() => _AppbarTitleState();
}

class _AppbarTitleState extends State<AppbarTitle> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    _readCurrentPageIndex();
    widget.currentPageNotifier.addListener(_handlePageIndex);
    super.initState();
  }

  @override
  void dispose() {
    widget.currentPageNotifier.removeListener(_handlePageIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_appbarTitle());
  }

  String _appbarTitle() {
    switch (_currentPageIndex + 1) {
      case 1:
        return "Kulliyah & session";
      case 2:
        return "Course codes";
      case 3:
        return "Almost there";
      default:
        return "";
    }
  }

  _handlePageIndex() {
    setState(_readCurrentPageIndex);
  }

  _readCurrentPageIndex() {
    _currentPageIndex = widget.currentPageNotifier.value;
  }
}
