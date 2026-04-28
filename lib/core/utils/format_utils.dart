import 'package:intl/intl.dart';

class FormatUtils {
  static final _dateFormatter = DateFormat('dd/MM/yyyy');
  static final _dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');
  static final _monthYearFormatter = DateFormat('MMMM yyyy', 'fr_FR');
  static final _currencyFormatter = NumberFormat('#,##0', 'fr_FR');

  static String formatDate(DateTime? date) {
    if (date == null) return '—';
    return _dateFormatter.format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '—';
    return _dateTimeFormatter.format(date);
  }

  static String formatMonthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  static String formatFcfa(double? amount) {
    if (amount == null) return '0 FCFA';
    return '${_currencyFormatter.format(amount)} FCFA';
  }

  static String formatFcfaCompact(double? amount) {
    if (amount == null) return '0';
    if (amount >= 1000000) {
      return '${_currencyFormatter.format(amount / 1000000)} M FCFA';
    }
    if (amount >= 1000) {
      return '${_currencyFormatter.format(amount / 1000)} k FCFA';
    }
    return '${_currencyFormatter.format(amount)} FCFA';
  }

  static String formatPercent(double? value) {
    if (value == null) return '0 %';
    return '${value.toStringAsFixed(1)} %';
  }

  /// Numéro temporaire pour les documents créés offline
  static String generateLocalNumero(String prefix) {
    final now = DateTime.now();
    return '$prefix-LOCAL-${now.year}-${now.millisecondsSinceEpoch}';
  }
}
