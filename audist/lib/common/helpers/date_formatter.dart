import 'package:intl/intl.dart';

class DateFormatter {
  // Format DateTime to "dd-MM-yyyy"
  static String formatDate(DateTime? date) {
    if (date == null) return "-"; // fallback for null dates
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  // Format DateTime to "dd-MM-yyyy HH:mm"
  static String formatDateTime(DateTime? date) {
    if (date == null) return "-";
    final formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(date);
  }

  // Format DateTime to "MMM dd, yyyy"
  static String formatLongDate(DateTime? date) {
    if (date == null) return "-";
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  static DateTime? parseIso(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    try {
      return DateTime.parse(isoString).toLocal();
    } catch (e) {
      return null;
    }
  }
}
