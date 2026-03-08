import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timetable_view/src/utils/utils.dart';

void main() {
  group('Utils.hourFormatter', () {
    group('24-hour format (default)', () {
      test('adds leading zero for single-digit hour', () {
        expect(Utils.hourFormatter(8, 30), '08:30');
      });

      test('formats double-digit hour correctly', () {
        expect(Utils.hourFormatter(14, 45), '14:45');
      });

      test('adds leading zero for single-digit minute', () {
        expect(Utils.hourFormatter(9, 5), '09:05');
      });

      test('hour-only omits minutes', () {
        expect(Utils.hourFormatter(14, 0, false), '14');
      });

      test('hour-only adds leading zero for single-digit hour', () {
        expect(Utils.hourFormatter(8, 0, false), '08');
      });

      test('midnight formats as 00:00', () {
        expect(Utils.hourFormatter(0, 0), '00:00');
      });

      test('noon formats as 12:00', () {
        expect(Utils.hourFormatter(12, 0), '12:00');
      });
    });

    group('12-hour format', () {
      test('AM time with minutes', () {
        expect(Utils.hourFormatter(8, 30, true, false), '8:30 am');
      });

      test('PM time with minutes', () {
        expect(Utils.hourFormatter(14, 45, true, false), '2:45 pm');
      });

      test('AM hour-only', () {
        expect(Utils.hourFormatter(8, 0, false, false), '8 am');
      });

      test('PM hour-only', () {
        expect(Utils.hourFormatter(14, 0, false, false), '2 pm');
      });

      test('midnight shows as 12:00 am', () {
        expect(Utils.hourFormatter(0, 0, true, false), '12:00 am');
      });

      test('noon shows as 12:00 pm', () {
        expect(Utils.hourFormatter(12, 0, true, false), '12:00 pm');
      });

      test('adds leading zero for single-digit minute', () {
        expect(Utils.hourFormatter(9, 5, true, false), '9:05 am');
      });
    });
  });

  group('Utils.sameDay', () {
    test('returns true for the same date regardless of time', () {
      final date = DateTime(2024, 3, 7);
      final target = DateTime(2024, 3, 7, 14, 30);
      expect(Utils.sameDay(date, target), isTrue);
    });

    test('returns false for different dates', () {
      final date = DateTime(2024, 3, 7);
      final target = DateTime(2024, 3, 8);
      expect(Utils.sameDay(date, target), isFalse);
    });
  });

  group('Utils.removeLastWord', () {
    test('removes the last word from a two-word string', () {
      expect(Utils.removeLastWord('Hello World'), 'Hello');
    });

    test('removes last word from multi-word string', () {
      expect(Utils.removeLastWord('one two three'), 'one two');
    });

    test('returns empty string for a single word', () {
      expect(Utils.removeLastWord('Hello'), '');
    });

    test('returns empty string for empty input', () {
      expect(Utils.removeLastWord(''), '');
    });
  });

  group('Utils.dateFormatter', () {
    test('adds leading zeros for single-digit month and day', () {
      expect(Utils.dateFormatter(2024, 3, 7), '2024-03-07');
    });

    test('does not add leading zeros for double-digit month and day', () {
      expect(Utils.dateFormatter(2024, 11, 25), '2024-11-25');
    });
  });
}
