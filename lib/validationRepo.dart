// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'json/countryModel.dart';
import 'userModel.dart';

class Validators{
   var url = 'https://parentstree-server.herokuapp.com';
  
  Future<bool> checkConnection() async{
    var response = await http.get(Uri.parse('$url/checkConnection'));
    if(response.statusCode==200){
      return true;
    }
    return false;
  }

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


  Future<User?> signIn(String login, String password) async{
    User user;
    var response = await http.post(Uri.parse('$url/signIn'),
    headers: {
      'Content-Type': 'application/json'
    },
    body: jsonEncode(<String, String>{
      'login':login,
      'password':password
    })
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
        id: currentUser['user']['_id']
      );
    }else{
      return null;
    }
    
    
  }

  Future<bool> checkEmail(String email) async{
    var response = await http.post(Uri.parse('$url/check/email'),
    headers: {
      'Content-Type': 'application/json'
    },
    body: jsonEncode(<String,String>{
      'email':email
    }));
    if(response.statusCode==200){
      return true;
    }
      return false;
  }

  Future<bool> checkUsername(String username) async{
    var response = await http.post(Uri.parse('$url/check/name'),
    headers: {
      'Content-Type': 'application/json'
    },
    body: jsonEncode(<String,String>{
      'name':username
    }));
    if(response.statusCode==200){
      return true;
    }else{
      return false;
    }
      
  }

  Future<bool> checkPhone(String phone) async{
    var response = await http.post(Uri.parse('$url/check/phone'),
    headers: {
      'Content-Type': 'application/json'
    },
    body: jsonEncode(<String,String>{
      'phone':phone
    }));
    if(response.statusCode==200){
      return true;
    }
      return false;
  }

  Future<bool> deleteUser(String token) async{
    var response = await http.delete(Uri.parse('$url/delete/user'),
    headers: {
      'token':token
    },
    );
    if(response.statusCode==200){
      return true;
    }else{
       return false;
    }
     
  }

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

  Future<User?> getMe(String token) async{
    var response = await http.get(Uri.parse('$url/me'),
    headers: {
      'token':token
    }
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
        realmToken: currentUser['realmToken']
      );
    }else{
      return null;
    }
  }

  Future<List> countries(String loc) async{
    var url = 'https://drive.google.com/uc?id=1SuvADk8EeyXU0vjQ159W9Kuxw4Mi_dGA&exprt=download';
    var response = await http.get(Uri.parse(url));
    var countries = [];
    var currentCountry = Country();
    
    if(response.statusCode==200){
      countries = jsonDecode(response.body);
      for (var item in countries) {
        if(loc.toString().toUpperCase().contains(item['iso2_cc'])){
          countries=[
            item['iso2_cc'],
            item['e164_cc'],
            item['example']
          ];
          // currentCountry..iso2Cc=item['iso2_cc']
          //               ..e164Cc = item['e164_cc'];
        }
      }
    }else{
    }
    return countries;
  }
        
  Future<List> countriesFlag(String country) async{
    var url = 'https://drive.google.com/uc?id=1SuvADk8EeyXU0vjQ159W9Kuxw4Mi_dGA&exprt=download';
    var response = await http.get(Uri.parse(url));
    var countries = [];
    
    if(response.statusCode==200){
      countries = jsonDecode(response.body);
      if(country.isNotEmpty){
        for (var item in countries) {
                if(country==item['iso2_cc']){
                  countries=[
                    item['iso2_cc'],
                    item['e164_cc'],
                    item['example']
                  ];
                  // currentCountry..iso2Cc=item['iso2_cc']
                  //               ..e164Cc = item['e164_cc'];
                  break;
                }
              }
      }else{
      countries= [
        'AM', '374', '77123456'
      ];
    }
    }
    return countries;
  }
}