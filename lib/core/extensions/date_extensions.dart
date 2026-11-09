// Date extensions and month clamping helper

extension DateExtensions on DateTime {
  DateTime addMonthsClamped(int months) {
    int newYear = year;
    int newMonth = month + months;

    while (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    while (newMonth < 1) {
      newYear--;
      newMonth += 12;
    }

    final int daysInTargetMonth = DateTime(newYear, newMonth + 1, 0).day;
    final int clampedDay = day > daysInTargetMonth ? daysInTargetMonth : day;

    return DateTime(newYear, newMonth, clampedDay);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isBeforeDay(DateTime other) {
    final a = DateTime(year, month, day);
    final b = DateTime(other.year, other.month, other.day);
    return a.isBefore(b);
  }

  bool isAfterDay(DateTime other) {
    final a = DateTime(year, month, day);
    final b = DateTime(other.year, other.month, other.day);
    return a.isAfter(b);
  }

  bool isSameOrBeforeDay(DateTime other) {
    return isSameDay(other) || isBeforeDay(other);
  }

  bool isSameOrAfterDay(DateTime other) {
    return isSameDay(other) || isAfterDay(other);
  }

  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }
}
