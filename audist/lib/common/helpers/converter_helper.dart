import 'package:intl/intl.dart';

class ConverterHelper {
  ConverterHelper._(); // Private constructor to prevent instantiation

  // -----------------------
  // DateTime Conversions
  // -----------------------

  /// Parse ISO 8601 string from server to DateTime
  static DateTime parseDate(String isoDate) {
    return DateTime.parse(isoDate).toLocal();
  }

  static DateTime parseDDMMYYYYDate(String date) {
    return DateFormat('dd/MM/yyyy').parseStrict(date);
  }

  static bool isValidDateString(String input) {
    if (input.isEmpty || input.contains('YYYY')) return false;

    try {
      DateFormat('yyyy-MM-dd').parseStrict(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  static DateTime parseStrDate(String input) {
    return DateFormat('yyyy-MM-dd').parseStrict(input);
  }

  /// Format ISO Date string to 'dd/MM/yyyy'
  static String formatDate(String isoDate) {
    final dateTime = parseDate(isoDate);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  /// Format ISO Date string to custom pattern
  static String formatDateCustom(String isoDate, String pattern) {
    final dateTime = parseDate(isoDate);
    return DateFormat(pattern).format(dateTime);
  }

  /// Format ISO Date string to time 'HH:mm'
  static String formatTime(String isoDate) {
    final dateTime = parseDate(isoDate);
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Convert DateTime object to string with default format 'dd/MM/yyyy'
  static String dateTimeToString(
    DateTime dateTime, {
    String pattern = 'yyyy-MM-dd',
  }) {
    return DateFormat(pattern).format(dateTime);
  }

  /// Convert DateTime object to time string 'HH:mm:ss'
  static String dateTimeToTimeString(
    DateTime dateTime, {
    String pattern = 'HH:mm:ss',
  }) {
    return DateFormat(pattern).format(dateTime);
  }

  /// Convert DateTime object to custom string format
  static String dateTimeToCustomString(DateTime dateTime, String pattern) {
    return DateFormat(pattern).format(dateTime);
  }

  // -----------------------
  // Number Conversions
  // -----------------------

  static String doubleToString(double value, {int decimalDigits = 2}) =>
      value.toStringAsFixed(decimalDigits);
  static String intToString(int value) => value.toString();
  static double stringToDouble(String value, {double defaultValue = 0}) =>
      double.tryParse(value) ?? defaultValue;
  static int stringToInt(String value, {int defaultValue = 0}) =>
      int.tryParse(value) ?? defaultValue;

  static String formatCurrency(
    double value, {
    String locale = 'en_US',
    String symbol = '₨ ',
    int decimalDigits = 2,
  }) {
    return NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(value);
  }

  static String formatNumber(double value, {int decimalDigits = 2}) {
    return NumberFormat('#,##0.${'0' * decimalDigits}').format(value);
  }

  static String formatPercentage(double value, {int decimalDigits = 2}) =>
      "${value.toStringAsFixed(decimalDigits)}%";

  // -----------------------
  // Boolean Conversions
  // -----------------------

  static String boolToYesNo(bool value) => value ? 'Yes' : 'No';
  static String boolToCustomString(
    bool value, {
    required String trueValue,
    required String falseValue,
  }) => value ? trueValue : falseValue;
  static bool stringToBool(String value) =>
      value.toLowerCase() == 'true' || value == '1';
  static bool intToBool(int value) => value != 0;
  static int boolToInt(bool value) => value ? 1 : 0;

  // -----------------------
  // Null-safe conversions
  // -----------------------

  static String objectToString(Object? value, {String defaultValue = ''}) =>
      value?.toString() ?? defaultValue;

  static double objectToDouble(Object? value, {double defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return stringToDouble(value, defaultValue: defaultValue);
    }
    return defaultValue;
  }

  static int objectToInt(Object? value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return stringToInt(value, defaultValue: defaultValue);
    return defaultValue;
  }
}
