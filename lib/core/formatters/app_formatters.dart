import 'package:intl/intl.dart';

class AppFormatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final NumberFormat _numberFormat =
      NumberFormat.decimalPattern('id_ID');

  static String formatRupiah(int amount) {
    return _currencyFormat.format(amount).trim();
  }

  static String formatKm(int km) {
    return '${_numberFormat.format(km)} km';
  }

  static String formatNumber(int number) {
    return _numberFormat.format(number);
  }

  static String formatDateIndonesian(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String formatDateBusiness(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static DateTime parseDateBusiness(String dateStr) {
    final parts = dateStr.split('-');
    if (parts.length != 3) {
      return DateTime.now();
    }
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
