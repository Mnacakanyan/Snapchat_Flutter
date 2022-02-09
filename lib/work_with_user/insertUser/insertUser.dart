import 'dart:convert';

import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:http/http.dart' as http;
import 'package:objectid/objectid.dart';
import 'package:snapchat_ui/userModel.dart';

class InsertUser {
  
  var url = 'https://parentstree-server.herokuapp.com';
  final MongoRealmClient client = MongoRealmClient();
  final RealmApp app = RealmApp();

  Future<User?> addUser(User user) async{
    var response = await http.post(Uri.parse('$url/addUser'),
    headers: {
      'Content-Type': 'application/json',
    },
      body: jsonEncode(<String, String>{
        'firstName': user.firstName.toString(),
        'lastName': user.lastName.toString(),
        'password': user.password.toString(),
        'email': user.email.toString(),
        'phone':  user.number.toString(),
        'name': user.username.toString(),
        'birthDate': user.birthDay.toString(),
        'country': user.iso2Cc.toString()
      }
    )
    );
    Map currentUser = jsonDecode(response.body);
    if(response.statusCode==200){
      
      return User(
        createdTokenForUser: currentUser['createdTokenForUser'],
        firstName: currentUser['user']['firstName'],
        lastName: currentUser['user']['lastName'],
        password: currentUser['user']['password'],
        email: currentUser['user']['email'],
        number: currentUser['user']['phone'],
        username: currentUser['user']['name'],
        birthDay: currentUser['user']['birthDate'],
        iso2Cc: currentUser['user']['country'],
        id: currentUser['user']['_id'],
        realmToken: currentUser['realmToken']
      );
    }else{
      return null;
    }
  }
  Future<void> initData(User user) async {
    final id = ObjectId();
    await app.login(Credentials.jwt(user.realmToken.toString()));
    var collection = client.getDatabase('todo').getCollection('Task');
    MongoDocument document = MongoDocument({
      '_partition':user.id.toString(),
      '_id':'$id',
      'firstName': user.firstName.toString(),
      'lastName': user.lastName.toString(),
      'password': user.password.toString(),
      'email': user.email.toString(),
      'phone': user.number.toString(),
      'userName': user.username.toString(),
      'birthDate': user.birthDay.toString(),
      'country':user.iso2Cc.toString()
    });
    await collection.insertOne(document);
  }
}