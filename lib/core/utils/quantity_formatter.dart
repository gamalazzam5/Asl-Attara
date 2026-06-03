class QuantityFormatter {
  const QuantityFormatter._();

  static String format(
    double quantity,
    String unit, {
    bool includeSign = false,
  }) {
    final converted = _convertedQuantity(quantity, unit);
    final sign = includeSign && converted.value > 0 ? '+' : '';

    return '$sign${formatNumber(converted.value)} ${converted.unit}';
  }

  static String formatNumber(double value) {
    final rounded = value.toStringAsFixed(3);

    return rounded
        .replaceFirst(RegExp(r'\.?0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  static _FormattedQuantity _convertedQuantity(double quantity, String unit) {
    final normalizedUnit = unit.trim();
    final lowerUnit = normalizedUnit.toLowerCase();
    final absoluteQuantity = quantity.abs();

    if (absoluteQuantity > 0 && absoluteQuantity < 1) {
      if (_isKilogram(lowerUnit)) {
        return _FormattedQuantity(quantity * 1000, 'جرام');
      }

      if (_isLiter(lowerUnit)) {
        return _FormattedQuantity(quantity * 1000, 'مل');
      }
    }

    return _FormattedQuantity(quantity, normalizedUnit);
  }

  static bool _isKilogram(String unit) {
    return unit == 'كجم' ||
        unit == 'kg' ||
        unit == 'كيلو' ||
        unit == 'كيلوجرام';
  }

  static bool _isLiter(String unit) {
    return unit == 'لتر' || unit == 'liter' || unit == 'litre' || unit == 'l';
  }
}

class _FormattedQuantity {
  final double value;
  final String unit;

  const _FormattedQuantity(this.value, this.unit);
}
