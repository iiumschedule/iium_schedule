import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/table_event_time.dart';

class TableEvent {
  final String title;

  // Default to startTime - endTime
  final String? subtitle;

  final TableEventTime start;

  final TableEventTime end;

  final EdgeInsets padding;

  final EdgeInsets? margin;

  final VoidCallback? onTap;

  final BoxDecoration? decoration;

  final Color backgroundColor;

  final TextStyle textStyle;

  final String? heroTag;

  TableEvent({
    required this.title,
    required this.start,
    required this.end,
    this.subtitle,
    this.padding = const EdgeInsets.all(10),
    this.margin,
    this.onTap,
    this.decoration,
    this.backgroundColor = const Color(0xCC2196F3),
    this.textStyle = const TextStyle(color: Colors.white),
    this.heroTag,
  }) : assert(end.isAfter(start));
}
