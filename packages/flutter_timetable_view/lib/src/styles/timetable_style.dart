import 'package:flutter/material.dart';

class TimetableStyle {
  final int startHour;

  final int endHour;

  final Color laneColor;

  final Color cornerColor;

  final Color timeItemTextColor;

  final Color timelineColor;

  final Color timelineItemColor;

  final Color mainBackgroundColor;

  final Color timelineBorderColor;

  final Color decorationLineBorderColor;

  final double laneWidth;

  final double laneHeight;

  final double timeItemHeight;

  final double timeItemWidth;

  final double decorationLineHeight;

  final double decorationLineDashWidth;

  final double decorationLineDashSpaceWidth;

  final bool visibleTimeBorder;

  final bool visibleDecorationBorder;

  const TimetableStyle({
    this.startHour = 0,
    this.endHour = 24,
    this.laneColor = Colors.white,
    this.cornerColor = Colors.white,
    this.timelineColor = Colors.white,
    this.timelineItemColor = Colors.white,
    this.mainBackgroundColor = Colors.white,
    this.decorationLineBorderColor = const Color(0x1A000000),
    this.timelineBorderColor = const Color(0x1A000000),
    this.timeItemTextColor = Colors.blue,
    this.laneWidth = 300,
    this.laneHeight = 70,
    this.timeItemHeight = 60,
    this.timeItemWidth = 70,
    this.decorationLineHeight = 20,
    this.decorationLineDashWidth = 9,
    this.decorationLineDashSpaceWidth = 4,
    this.visibleTimeBorder = true,
    this.visibleDecorationBorder = false,
  });
}
