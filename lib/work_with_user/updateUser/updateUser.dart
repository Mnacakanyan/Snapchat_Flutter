import 'dart:convert';

import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:http/http.dart' as http;
import 'package:snapchat_ui/userModel.dart';

class UpdateUser{
  var url = 'https://parentstree-server.herokuapp.com';
  Future<User?> editAccount(
    String token,
    String? firstName,
    String? password,
    String? email,
    String? lastName,
    String? phone,
    String? name,
    String? birthDate,
    String? iso2Cc
    ) async{
    var response = await http.post(Uri.parse('$url/editAccount'),
    headers: {
      'Content-Type': 'application/json',
      'token':token,
    },
    body: jsonEncode(<String,String>{
        'firstName': firstName.toString(),
        'password': password.toString(),
        'email': email.toString(),
        'lastName': lastName.toString(),
        'phone': phone.toString(),
        'name': name.toString(),
        'birthDate': birthDate.toString(),
        'country':iso2Cc.toString()
    })
    );
    var result = jsonDecode(response.body);
    var result1 = result['user'];
    if(response.statusCode==200){
      return User(
      firstName: result1['firstName'],
      lastName: result1['lastName'],
      username: result1['name'],
      birthDay: result1['birthDate'],
      email: result1['email'],
      number: result1['phone'],
      iso2Cc: result1['country']
      );
    }else{
      return null;
    }
  }

  Future<void> updateMongo(String username, User user) async{
    MongoCollection mongoCollection = MongoCollection(databaseName: 'todo', collectionName: 'Task');
    await mongoCollection.updateMany(
      filter: {
        'userName': username
      }, 
      update: UpdateOperator.set(
        {
          'firstName': user.firstName.toString(),
          'lastName': user.lastName.toString(),
          'password': user.password.toString(),
          'email': user.email.toString(),
          'phone': user.number.toString(),
          'userName': user.username.toString(),
          'birthDate': user.birthDay.toString(),
          'country':user.iso2Cc.toString()
        }
      ));
  }

}