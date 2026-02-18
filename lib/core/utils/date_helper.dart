import 'package:intl/intl.dart';

class DateHelper {
  /// Format date to readable string (e.g., "Jan 15, 2026")
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format date to short string (e.g., "15/01/2026")
  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Calculate number of nights between two dates
  static int calculateNights(DateTime checkIn, DateTime checkOut) {
    return checkOut.difference(checkIn).inDays;
  }

  /// Check if date is in the past
  static bool isPastDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isBefore(today);
  }

  /// Check if checkout is after checkin
  static bool isValidDateRange(DateTime checkIn, DateTime checkOut) {
    return checkOut.isAfter(checkIn);
  }

  /// Get today's date with time set to midnight
  static DateTime getToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Normalize date to midnight (remove time component)
  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
