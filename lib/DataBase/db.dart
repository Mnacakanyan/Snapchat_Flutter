// ignore_for_file: cascade_invocations

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snapchat_ui/DataBase/api.dart';
import 'package:snapchat_ui/json/countryModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  static List? list1;
  DBProvider._();

  Future<List> get listOfCountry async {
    if (list1 != null) return list1!;
    list1 = await CountryApiProvider.ins.getAllCountries();

    return list1!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'country.db');
    return await openDatabase(path, version: 3, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE CountryList( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, e164_cc TEXT, name TEXT, iso2_cc TEXT, example TEXT) ');
      var response = await http
          .get(Uri.parse('https://parentstree-server.herokuapp.com/countries'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var data2 = data['countries'];
        // var list = (data as List).map((e) => Country.fromJson(e)).toList()
        data2.forEach((element) {
          var batch = db.batch();
          batch.insert('CountryList', {
            'e164_cc': element['e164_cc'],
            'name': element['name'],
            'iso2_cc': element['iso2_cc'],
            'example': element['example']
          });
          batch.commit();
        });
      }
    });
  }

  Future<List<Country>> getAllCountries() async {
    final db = await database;
    var myList = await db.rawQuery('SELECT * FROM CountryList');
    List<Country> countryList = [];
    myList.forEach((element) {
      countryList.add(Country.fromJson(element));
    });
    return countryList;
  }

  Future<List<Country>?>? filterCountry(String countryName) async {
    final db = await database;
    if (countryName == '') {
      return null;
    }
    final res = await db.query('CountryList',
        where: 'name LIKE ?', whereArgs: ['$countryName%']);
    List<Country> filteredCounties = [];
    res.forEach((element) {
      filteredCounties.add(Country.fromJson(element));
    });
    return filteredCounties;
  }
}
