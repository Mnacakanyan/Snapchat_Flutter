
// ignore_for_file: avoid_bool_literals_in_conditional_expressions

class Repo{
  var regEx = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool firstName(String firstName){
    return (firstName.length>0)?true:false;
  }
  bool lastName(String lastName){
    return (lastName.length>0)?true:false;
  }
  bool email(String email){
    return (regEx.hasMatch(email))?true:false;
  }
  bool username(String username){
    return (username.length>4)?true:false;
  }
  bool password(String password){
    return (password.length>7)?true:false;
  }
}