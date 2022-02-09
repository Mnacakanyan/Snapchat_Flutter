// ignore_for_file: cascade_invocations

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snapchat_ui/userModel.dart';
import 'package:sqflite/sqflite.dart';

class UsersDB {
  UsersDB._();
  static UsersDB ins = UsersDB._();
  static Database? userDB;
  static Database? currentUserDB;

  Future<Database> get database async {
    if (userDB != null) return userDB!;
    userDB = await userFromServer();
    return userDB!;
  }

  Future<Database> userFromServer() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'usersDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS UsersDB(id TEXT, firstName TEXT,lastName TEXT, password TEXT, email TEXT, phone TEXT, name TEXT, birthDate TEXT ) ');
    });
  }

  Future<List> getUsers() async{
    final db = await database;
    var url = 'https://parentstree-server.herokuapp.com/allUsers';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    var allUsers = jsonDecode(response.body);
    var users = allUsers['users'];
    for (var i in users) {
      if(db.isOpen){
        await db.rawInsert('INSERT INTO UsersDB(id,firstName,lastName,password,email,phone,name,birthDate) VALUES(?,?,?,?,?,?,?,?)',[i['_id'],i['firstName'],i['lastName'], i['password'], i['email'], i['phone'], i['name'], i['birthDate']]);
      }
      
    }
    
    var result = await db.rawQuery('SELECT * FROM UsersDB');
    // var r = await db.rawDelete('DELETE FROM UsersDB WHERE name = ?', ['jcjcjgjgjvk']);
    return result;
  }

Future<Map> user(String token) async{

    var url = 'https://parentstree-server.herokuapp.com/me';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'token':token,
    },);
    var result = jsonDecode(response.body);
    var res = result['user'];
    return res;
}


  Future<Database> initUser(User user) async{
    var version = 2;
    var documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'currentUser1.db');
    return await openDatabase(path, version: version, 
    onOpen: (Database db) async{
    },
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE CurrentUser( firstName TEXT ,lastName TEXT , password TEXT , email TEXT, phone TEXT, name TEXT, birthDate TEXT, token TEXT) ',);
          var batch = db.batch();
          batch.insert('CurrentUser', {
            'firstName':user.firstName,
            'lastName':user.lastName,
            'password':user.password,
            'email':user.email,
            'phone':user.number,
            'name':user.username,
            'birthDate':user.birthDay,
            'token':user.createdTokenForUser
          });
          batch.commit();
          
    });
  }


  Future closeDB() async{
    final db = await database;
    db.close();
  }
}
