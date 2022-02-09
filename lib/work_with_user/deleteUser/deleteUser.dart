import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:http/http.dart' as http;

class DeleteUser{
  var url = 'https://parentstree-server.herokuapp.com';

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

  Future<bool> deleteUserFromMongo(String username) async{
    MongoCollection mongoCollection = MongoCollection(databaseName: 'todo', collectionName: 'Task');
    var delete = await mongoCollection.deleteOne(
      {
        'userName':username,
      }
    );
    if(delete==1){
      return true;
    }else{
      return false;
    }
  }
}