import 'package:intl/intl.dart';

extension RelativeDate on DateTime {
  /// Returns the upcoming date in the format of "in 2 days" or "in this week"
  /// If the upcoming date is more than a week, return the formatted date
  String toRelativeDate() {
    final now = DateTime.now();
    final diff = difference(now);

    if (diff.inDays == 0) {
      var examTime = DateFormat('h:mm a').format(this);
      // The inDays is 0, can be today or tomorrow (0d 23 hours 59 mins 59 secs)
      if (isToday()) {
        return "Today, $examTime";
      } else {
        return "Tomorrow, $examTime";
      }
    } else if (diff.inDays < 7) {
      // handle singular & plural
      if (diff.inDays == 1) {
        return "In ${diff.inDays} day";
      }
      return "In ${diff.inDays} days";
    } else {
      return DateFormat('E, d MMM yyyy').format(this);
    }
  }

  /// Check if given day in same day as today
  bool isToday() {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }
}
