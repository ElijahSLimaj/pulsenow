import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _compactCurrencyFormatter = NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _compactNumberFormatter = NumberFormat.compact();

  static String formatCurrency(double value) {
    if (value >= 1000000) {
      return _compactCurrencyFormatter.format(value);
    }
    return _currencyFormatter.format(value);
  }

  static String formatPrice(double value) {
    if (value < 1) {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 4).format(value);
    }
    return _currencyFormatter.format(value);
  }

  static String formatPercentage(double value) {
    final prefix = value >= 0 ? '+' : '';
    return '$prefix${value.toStringAsFixed(2)}%';
  }

  static String formatVolume(double value) {
    return _compactNumberFormatter.format(value);
  }

  static String formatMarketCap(double value) {
    return _compactCurrencyFormatter.format(value);
  }
}
