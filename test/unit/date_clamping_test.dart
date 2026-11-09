import 'package:flutter_test/flutter_test.dart';
import 'package:servis/core/extensions/date_extensions.dart';

void main() {
  group('DateExtensions addMonthsClamped Tests', () {
    test('Clamps Jan 31 in non-leap year to Feb 28', () {
      final jan31 = DateTime(2026, 1, 31);
      final feb = jan31.addMonthsClamped(1);

      expect(feb.year, 2026);
      expect(feb.month, 2);
      expect(feb.day, 28);
    });

    test('Clamps Jan 31 in leap year to Feb 29', () {
      final jan31Leap = DateTime(2024, 1, 31);
      final febLeap = jan31Leap.addMonthsClamped(1);

      expect(febLeap.year, 2024);
      expect(febLeap.month, 2);
      expect(febLeap.day, 29);
    });

    test('Clamps 31st day to 30th day for 30-day months', () {
      final mar31 = DateTime(2026, 3, 31);
      final apr = mar31.addMonthsClamped(1);
      expect(apr.month, 4);
      expect(apr.day, 30);

      final may31 = DateTime(2026, 5, 31);
      final jun = may31.addMonthsClamped(1);
      expect(jun.month, 6);
      expect(jun.day, 30);

      final aug31 = DateTime(2026, 8, 31);
      final sep = aug31.addMonthsClamped(1);
      expect(sep.month, 9);
      expect(sep.day, 30);

      final oct31 = DateTime(2026, 10, 31);
      final nov = oct31.addMonthsClamped(1);
      expect(nov.month, 11);
      expect(nov.day, 30);
    });

    test('Handles year rollover correctly', () {
      final dec31 = DateTime(2026, 12, 31);
      final jan = dec31.addMonthsClamped(1);
      expect(jan.year, 2027);
      expect(jan.month, 1);
      expect(jan.day, 31);

      final nov15 = DateTime(2026, 11, 15);
      final feb = nov15.addMonthsClamped(3);
      expect(feb.year, 2027);
      expect(feb.month, 2);
      expect(feb.day, 15);
    });

    test('Normal date preserves exact day of month', () {
      final jan15 = DateTime(2026, 1, 15);
      final apr15 = jan15.addMonthsClamped(3);
      expect(apr15.year, 2026);
      expect(apr15.month, 4);
      expect(apr15.day, 15);
    });
  });
}
