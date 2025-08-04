import 'package:intl/intl.dart';

class Date {
  static String formatDateToDDMMYYYY(String inputDate) {
    try {
      final DateTime parsed = DateTime.parse(inputDate);
      return DateFormat('dd-MM-yyyy').format(parsed);
    } catch (e) {
      return inputDate; // fallback to original string if parsing fails
    }
  }

  static DateTime stringToDateTime(String dateString) {
    return DateTime.tryParse(dateString) ?? DateTime.now();
  }

  static DateTime getCurrentDate() {
    return DateTime.now();
  }


}
