import 'package:intl/intl.dart';

class DateFormatter {
  // "Jul 29, 2025"
  static String formatDateShort(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  // "29-07-2025"
  static String formatDateNumeric(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  // "07/29/2025 14:30"
  static String formatDateTimeShort(DateTime date) {
    return DateFormat('MM/dd/yyyy HH:mm').format(date);
  }

  // "July 29, 2025 2:30 PM"
  static String formatDateTimeLong(DateTime date) {
    return DateFormat('MMMM d, yyyy h:mm a').format(date);
  }

  // "2:30 PM"
  static String formatTimeShort(DateTime date) {
    return DateFormat('HH:mm a').format(date);
  }

  // Parse string to DateTime
  static DateTime? parseDate(String dateString, {String format = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null; 
    }
  }
}
