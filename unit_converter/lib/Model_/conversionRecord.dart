class ConversionRecord {
  final String category;
  final String fromUnit;
  final String toUnit;
  final double inputValue;
  final double result;
  final DateTime timestamp;

  ConversionRecord({
    required this.category,
    required this.fromUnit,
    required this.toUnit,
    required this.inputValue,
    required this.result,
    required this.timestamp,
  });

  String get summary =>
      '${_trim(inputValue)} $fromUnit = ${_trim(result)} $toUnit';

  static String _trim(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(4).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
}

class FavoriteConversion {
  final String category;
  final String fromUnit;
  final String toUnit;

  FavoriteConversion({
    required this.category,
    required this.fromUnit,
    required this.toUnit,
  });

  String get label => '$fromUnit → $toUnit';

  @override
  bool operator ==(Object other) =>
      other is FavoriteConversion &&
      other.category == category &&
      other.fromUnit == fromUnit &&
      other.toUnit == toUnit;

  @override
  int get hashCode => Object.hash(category, fromUnit, toUnit);
}
