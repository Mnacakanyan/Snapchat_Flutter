import 'package:flutter/material.dart';
import 'validationRepo.dart';

class MyLocator{
  var validator = Validators();
  Future<List<dynamic>> getLocale(BuildContext context) async {
    var loc = Localizations.localeOf(context);
      var local = await validator.countries(loc.countryCode.toString());
      return local;
  }

  Future<List<dynamic>> getNewLocale(String number) async{
    var connected = await validator.checkConnection();
    var local;
    if(connected){
      local = await validator.countriesFlag(number);
    }
    return local;
  }
}