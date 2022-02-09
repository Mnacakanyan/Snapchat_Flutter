import 'package:flutter/material.dart';
import 'json/countryModel.dart';

class ChangeCountryCode extends ChangeNotifier {
  Country _selected = Country();
  Country get country => _selected;

  void changeCountry(Country _country) {
    _selected = _country;
    notifyListeners();
  }
}

class MyValueNotifier {
  final ValueNotifier<Country> _country = ValueNotifier(Country());
  ValueNotifier<Country> get country => _country;
}
