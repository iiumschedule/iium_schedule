import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';

class Utils {
  static bool sameDay(DateTime date, [DateTime? target]) {
    target = target ?? DateTime.now();
    return target.year == date.year &&
        target.month == date.month &&
        target.day == date.day;
  }

  static String removeLastWord(String string) {
    List<String> words = string.split(' ');
    if (words.isEmpty) {
      return '';
    }

    return words.getRange(0, words.length - 1).join(' ');
  }

  static String dateFormatter(int year, int month, int day) {
    return '$year-${_addLeadingZero(month)}-${_addLeadingZero(day)}';
  }

  /// Formats an [hour] and [minute] into a display string for the timetable.
  ///
  /// Set [showMinutes] to false to render hour-only labels (e.g. timeline axis).
  /// Set [use24Hour] to false for 12-hour output.
  ///
  /// Examples:
  /// ```
  /// hourFormatter(8, 30)              → "08:30"
  /// hourFormatter(14, 0, false)       → "14"
  /// hourFormatter(8, 30, true, false) → "8:30 am"
  /// hourFormatter(14, 0, false, false)→ "2 pm"
  /// ```
  static String hourFormatter(
    int hour,
    int minute, [
    bool showMinutes = true,
    bool use24Hour = true,
  ]) {
    if (use24Hour) {
      return showMinutes
          ? '${_addLeadingZero(hour)}:${_addLeadingZero(minute)}'
          : _addLeadingZero(hour);
    } else {
      final int displayHour = hour % 12 == 0 ? 12 : hour % 12;
      final String period = hour < 12 ? 'am' : 'pm';
      return showMinutes
          ? '$displayHour:${_addLeadingZero(minute)} $period'
          : '$displayHour $period';
    }
  }

  static Widget eventText(
    TableEvent event,
    BuildContext context,
    double height,
    double width, {
    String? subtitle,
    bool use24Hour = true,
  }) {
    List<TextSpan> text = [
      TextSpan(
        text: event.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: subtitle != null
            ? ' $subtitle\n\n'
            : ' ${Utils.hourFormatter(event.start.hour, event.start.minute, true, use24Hour)} - ${Utils.hourFormatter(event.end.hour, event.end.minute, true, use24Hour)}\n\n',
      ),
    ];

    bool? exceedHeight;
    while (exceedHeight ?? true) {
      exceedHeight = _exceedHeight(text, event.textStyle, height, width);
      if (exceedHeight == null || !exceedHeight) {
        if (exceedHeight == null) {
          text.clear();
        }
        break;
      }

      if (!_ellipsize(text)) {
        break;
      }
    }

    return RichText(
      text: TextSpan(children: text, style: event.textStyle),
    );
  }

  static String _addLeadingZero(int number) {
    return (number < 10 ? '0' : '') + number.toString();
  }

  static bool? _exceedHeight(
    List<TextSpan> input,
    TextStyle textStyle,
    double height,
    double width,
  ) {
    double fontSize = textStyle.fontSize ?? 14;
    int maxLines = height ~/ ((textStyle.height ?? 1.2) * fontSize);
    if (maxLines == 0) {
      return null;
    }

    TextPainter painter = TextPainter(
      text: TextSpan(children: input, style: textStyle),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: width);
    return painter.didExceedMaxLines;
  }

  static bool _ellipsize(List<TextSpan> input, [String ellipse = '…']) {
    if (input.isEmpty) {
      return false;
    }

    TextSpan last = input.last;
    String text = last.text!;
    if (text.isEmpty || text == ellipse) {
      input.removeLast();

      if (text == ellipse) {
        _ellipsize(input, ellipse);
      }
      return true;
    }

    String truncatedText;
    if (text.endsWith('\n')) {
      truncatedText = text.substring(0, text.length - 1) + ellipse;
    } else {
      truncatedText = Utils.removeLastWord(text);
      truncatedText =
          truncatedText.substring(0, math.max(0, truncatedText.length - 2)) +
          ellipse;
    }

    input[input.length - 1] = TextSpan(text: truncatedText, style: last.style);

    return true;
  }
}
