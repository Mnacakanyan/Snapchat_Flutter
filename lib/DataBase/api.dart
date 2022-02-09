
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:snapchat_ui/json/countryModel.dart';

class CountryApiProvider {
  static CountryApiProvider ins = CountryApiProvider._();
  CountryApiProvider._();
  List<Country> myList = [];



  Future<List> getAllCountries() async {
    var url = 'https://parentstree-server.herokuapp.com/countries';
    // var response =  await Dio().get(url);
    var response =  await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    var data2 = data['countries'];
    // for(var a = 0; a<248;a++){
    //   myList.add(Country.fromJson(response.data['countries'][a]));
    //   print('res is ${response.data['countries'][a]}');
    // print('daar is ${data2}');
    var data1 = data2 as List;

    // data1.forEach((element) {
    //   myList.add(Country.fromJson(element));
    // });

    data1.map((e) => 
      Country.fromJson(e)
    ).toList();
    
    // for(var a in response.data['countries']){
    //   if(!(myList.length>247)){
        
    //     myList.add(Country.fromJson(a));
    //     }
    //   }
      // var a = jsonDecode(response.body);
      // for (var item in a) {
      //   if(!(myList.length>247)){
      //   print('1234');
      //   myList.add(Country.fromJson(item));
      //   }
      // }

    return data1;
  }
}