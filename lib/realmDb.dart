import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:objectid/objectid.dart';
import 'userModel.dart';

class RealmDB {
  final MongoRealmClient client = MongoRealmClient();
  final RealmApp app = RealmApp();

  // Future<void> initData(User user) async {
  //   final id = ObjectId();
  //   await app.login(Credentials.jwt(user.realmToken.toString()));
  //   var collection = client.getDatabase('todo').getCollection('Task');
  //   MongoDocument document = MongoDocument({
  //     '_partition':user.id.toString(),
  //     '_id':'$id',
  //     'firstName': user.firstName.toString(),
  //     'lastName': user.lastName.toString(),
  //     'password': user.password.toString(),
  //     'email': user.email.toString(),
  //     'phone': user.number.toString(),
  //     'userName': user.username.toString(),
  //     'birthDate': user.birthDay.toString(),
  //     'country':user.iso2Cc.toString()
  //   });
  //   await collection.insertOne(document);
  // }

  // Future<bool> checkEmail(String email) async{
  //   MongoCollection mongoCollection = MongoCollection(databaseName: 'todo', collectionName: 'Task');
  //   // var collection = client.getDatabase('Users').getCollection('users');
  //   var doc = await mongoCollection.findOne(
  //     filter: {
  //       'email':email
  //     },
  //     projection: {
  //     },

  //   );
  //   if(doc==null){
  //     return true;
  //   }else{
  //     return false;
  //   }

  // }
// Future<bool> checkNumber(String number) async{
//     MongoCollection mongoCollection = MongoCollection(databaseName: 'todo', collectionName: 'Task');
//     // var collection = client.getDatabase('Users').getCollection('users');
//     var doc = await mongoCollection.findOne(
//       filter: {
//         'phone':number
//       },
//       projection: {
//       },

//     );
//     if(doc==null){
//       return true;
//     }else{
//       return false;
//     }
//   }
  Future<bool> checkUsername(String username) async {
    MongoCollection mongoCollection =
        MongoCollection(databaseName: 'todo', collectionName: 'Task');
    // var collection = client.getDatabase('Users').getCollection('users');
    var doc = await mongoCollection.findOne(
      filter: {'userName': username},
      projection: {},
    );
    if (doc == null) {
      return true;
    } else {
      return false;
    }
  }
  // Future<void> updateUserInfo(String username, User user) async{
  //   MongoCollection mongoCollection = MongoCollection(databaseName: 'todo', collectionName: 'Task');
  //   await mongoCollection.updateMany(
  //     filter: {
  //       'userName': username
  //     },
  //     update: UpdateOperator.set(
  //       {
  //         'firstName': user.firstName.toString(),
  //         'lastName': user.lastName.toString(),
  //         'password': user.password.toString(),
  //         'email': user.email.toString(),
  //         'phone': user.number.toString(),
  //         'userName': user.username.toString(),
  //         'birthDate': user.birthDay.toString(),
  //         'country':user.iso2Cc.toString()
  //       }
  //     ));
  // }

  // Future<bool> deleteUser(String username) async{
  //   MongoCollection mongoCollection = MongoCollection(databaseName: 'todo', collectionName: 'Task');
  //   var delete = await mongoCollection.deleteOne(
  //     {
  //       'userName':username,
  //     }
  //   );
  //   if(delete==1){
  //     return true;
  //   }else{
  //     return false;
  //   }
  // }

  Future<User?> getUser(String username) async {
    MongoCollection mongoCollection =
        MongoCollection(databaseName: 'todo', collectionName: 'Task');
    var user = await mongoCollection
        .findOne(filter: {'userName': username}, projection: {});
    if (user != null) {
      return User(
          firstName: user.map['firstName'].toString(),
          lastName: user.map['lastName'].toString(),
          birthDay: user.map['birthDate'].toString(),
          password: user.map['password'].toString(),
          email: user.map['email'].toString(),
          username: user.map['userName'].toString(),
          number: user.map['phone'].toString(),
          iso2Cc: user.map['country'].toString());
    } else {
      return null;
    }
  }
}
