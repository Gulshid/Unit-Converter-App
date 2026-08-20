import 'package:flutter/material.dart';
import 'package:unit_converter/Model_/unitCategory.dart';
import 'package:unit_converter/Model_/conversionRecord.dart';

class Unitprovider with ChangeNotifier {
  static const String temperatureCategory = 'Temperature';

  final List<Unitcategory> categories = [
    Unitcategory(
      name: 'Length',
      icon: const Icon(Icons.straighten, color: Colors.black),
      units: {
        'Meter': 1.0,
        'Kilometer': 1000.0,
        'Centimeter': 0.01,
        'Millimeter': 0.001,
        'Mile': 1609.34,
        'Yard': 0.9144,
        'Foot': 0.3048,
        'Inch': 0.0254,
      },
    ),
    Unitcategory(
      name: 'Weight',
      icon: const Icon(Icons.scale, color: Colors.black),
      units: {
        'Gram': 1.0,
        'Kilogram': 1000.0,
        'Milligram': 0.001,
        'Pound': 453.592,
        'Ounce': 28.3495,
        'Tonne': 1000000.0,
      },
    ),
    Unitcategory(
      name: temperatureCategory,
      icon: const Icon(Icons.thermostat, color: Colors.black),
      units: {'Celsius': 1.0, 'Fahrenheit': 1.0, 'Kelvin': 1.0},
    ),
    Unitcategory(
      name: 'Time',
      icon: const Icon(Icons.access_time, color: Colors.black),
      units: {
        'Millisecond': 0.001,
        'Second': 1.0,
        'Minute': 60.0,
        'Hour': 3600.0,
        'Day': 86400.0,
        'Week': 604800.0,
      },
    ),
    Unitcategory(
      name: 'Area',
      icon: const Icon(Icons.crop_square, color: Colors.black),
      units: {
        'Square Meter': 1.0,
        'Square Kilometer': 1000000.0,
        'Hectare': 10000.0,
        'Acre': 4046.86,
        'Square Foot': 0.092903,
      },
    ),
    Unitcategory(
      name: 'Speed',
      icon: const Icon(Icons.speed, color: Colors.black),
      units: {
        'Meter/sec': 1.0,
        'Kilometer/hour': 0.277778,
        'Mile/hour': 0.44704,
        'Knot': 0.514444,
      },
    ),
    Unitcategory(
      name: 'Volume',
      icon: const Icon(Icons.water_drop, color: Colors.black),
      units: {
        'Liter': 1.0,
        'Milliliter': 0.001,
        'Cubic Meter': 1000.0,
        'Gallon (US)': 3.78541,
        'Cup': 0.24,
      },
    ),
    Unitcategory(
      name: 'Data',
      icon: const Icon(Icons.storage, color: Colors.black),
      units: {
        'Byte': 1.0,
        'Kilobyte': 1024.0,
        'Megabyte': 1048576.0,
        'Gigabyte': 1073741824.0,
        'Terabyte': 1099511627776.0,
      },
    ),
  ];

  late Unitcategory selectedCategory;
  String fromUnit = '';
  String toUnit = '';
  double result = 0.0;
  double _lastInputValue = 0.0;
  bool hasValue = false;

  bool isDarkMode = false;

  final List<ConversionRecord> history = [];
  final List<FavoriteConversion> favorites = [];

  Unitprovider() {
    selectedCategory = categories[0];
    fromUnit = selectedCategory.units.keys.first;
    toUnit = selectedCategory.units.keys.last;
  }

  // ignore: non_constant_identifier_names
  void ChangeCategory(Unitcategory category) {
    selectedCategory = category;
    fromUnit = category.units.keys.first;
    toUnit = category.units.keys.last;
    hasValue = false;
    result = 0.0;
    notifyListeners();
  }

  void setFromUnit(String unit) {
    fromUnit = unit;
    _recompute();
  }

  void setToUnit(String unit) {
    toUnit = unit;
    _recompute();
  }

  void swapUnits() {
    final temp = fromUnit;
    fromUnit = toUnit;
    toUnit = temp;
    _recompute();
  }

  /// Live conversion - called on every keystroke. Does not log history.
  // ignore: non_constant_identifier_names
  void Convert(double value) {
    _lastInputValue = value;
    hasValue = true;
    result = _computeConversion(fromUnit, toUnit, value);
    notifyListeners();
  }

  void _recompute() {
    if (hasValue) {
      result = _computeConversion(fromUnit, toUnit, _lastInputValue);
    }
    notifyListeners();
  }

  double _computeConversion(String from, String to, double value) {
    if (selectedCategory.name == temperatureCategory) {
      final celsius = _toCelsius(from, value);
      return _fromCelsius(to, celsius);
    }
    final fromRate = selectedCategory.units[from]!;
    final toRate = selectedCategory.units[to]!;
    return value * fromRate / toRate;
  }

  double _toCelsius(String unit, double value) {
    switch (unit) {
      case 'Fahrenheit':
        return (value - 32) * 5 / 9;
      case 'Kelvin':
        return value - 273.15;
      default:
        return value;
    }
  }

  double _fromCelsius(String unit, double celsius) {
    switch (unit) {
      case 'Fahrenheit':
        return (celsius * 9 / 5) + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  /// Commit the current conversion to history (called on submit / focus loss).
  void logToHistory() {
    if (!hasValue) return;
    final record = ConversionRecord(
      category: selectedCategory.name,
      fromUnit: fromUnit,
      toUnit: toUnit,
      inputValue: _lastInputValue,
      result: result,
      timestamp: DateTime.now(),
    );
    // Avoid consecutive duplicate entries.
    if (history.isNotEmpty && history.first.summary == record.summary) return;
    history.insert(0, record);
    if (history.length > 20) history.removeLast();
    notifyListeners();
  }

  void clearHistory() {
    history.clear();
    notifyListeners();
  }

  void applyHistoryRecord(ConversionRecord record) {
    final category = categories.firstWhere((c) => c.name == record.category);
    selectedCategory = category;
    fromUnit = record.fromUnit;
    toUnit = record.toUnit;
    _lastInputValue = record.inputValue;
    hasValue = true;
    result = record.result;
    notifyListeners();
  }

  bool get isCurrentFavorite => favorites.contains(
        FavoriteConversion(
          category: selectedCategory.name,
          fromUnit: fromUnit,
          toUnit: toUnit,
        ),
      );

  void toggleFavorite() {
    final fav = FavoriteConversion(
      category: selectedCategory.name,
      fromUnit: fromUnit,
      toUnit: toUnit,
    );
    if (favorites.contains(fav)) {
      favorites.remove(fav);
    } else {
      favorites.add(fav);
    }
    notifyListeners();
  }

  void removeFavorite(FavoriteConversion fav) {
    favorites.remove(fav);
    notifyListeners();
  }

  void applyFavorite(FavoriteConversion fav) {
    final category = categories.firstWhere((c) => c.name == fav.category);
    selectedCategory = category;
    fromUnit = fav.fromUnit;
    toUnit = fav.toUnit;
    _recompute();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
