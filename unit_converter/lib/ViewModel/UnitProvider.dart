import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unit_converter/Model_/unitCategory.dart';

class Unitprovider with ChangeNotifier {
  List<Unitcategory> categories = [
    Unitcategory(
      name: 'length',
      units: {
        'Meter': 1.0,
        'Kilometer': 1000.0,
        'Centimeter': 0.01,
        'Inch': 0.0254,
      },
    ),

    Unitcategory(
      name: 'Weight',
      units: {'Gram': 1.0, 'Kilogram': 1000.0, 'Pound': 453.592},
    ),

    Unitcategory(
      name: 'Tempreture',
      units: {'Celsius': 1.0, 'Fahrenheit': 1.0},
    ),

    Unitcategory(
      name: 'Time',
      units: {'Second': 1.0, 'Minute': 60.0, 'Hour': 3600.0},
    ),

    Unitcategory(
      name: 'Area',
      units: {'Square Meter': 1.0, 'Hectare': 10000.0, 'Acre': 4046.86},
    ),
  ];

  late Unitcategory selectedCategory;
  String fromUnit = '';
  String ToUnit = '';
  double result = 0.0;

  Unitprovider() {
    selectedCategory = categories[0];
    fromUnit = selectedCategory.units.keys.first;
    ToUnit = selectedCategory.units.keys.last;
  }

  void ChangeCategory(Unitcategory category) {
    selectedCategory = category;
    fromUnit = category.units.keys.first;
    ToUnit = category.units.keys.last;
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  void Convert(double value) {
    if (selectedCategory.name == 'Tempreture') {
      if (fromUnit == 'Celsius' && ToUnit == 'Fahrenheit') {
        result = (value * 9 / 5) + 32;
      } else if (fromUnit == 'Fahrenheit' && ToUnit == 'Celsius') {
        result = (value - 32) * 5 / 9;
      } else {
        result = value;
      }
    } else {
      double fromRate = selectedCategory.units[fromUnit]!;
      double ToRate = selectedCategory.units[ToUnit]!;
      result = value * fromRate / ToRate;
    }
    notifyListeners();
  }
}
