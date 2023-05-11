import 'package:intl/intl.dart';

class RelativeDate {
  /// Returns the upcoming date in the format of "in 2 days" or "in this week"
  /// If the upcoming date is more than a week, return the formatted date
  static String fromDate(DateTime dateTime) {
    final now = DateTime.now();
    final diff = dateTime.difference(now);

    if (diff.inDays == 0) {
      return "today";
    } else if (diff.inDays == 1) {
      return "tomorrow";
    } else if (diff.inDays < 7) {
      return "in ${diff.inDays} days";
    } else {
      return DateFormat('E, d MMM yyyy').format(dateTime);
    }
  }

  /// Check if given day in same day as today
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year;
  }
}
