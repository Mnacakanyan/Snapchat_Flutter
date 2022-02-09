part of 'login_bloc_bloc.dart';

abstract class LoginBlocState extends Equatable {
  const LoginBlocState();
  
  @override
  List<Object> get props => [];
}

class LoginBlocInitial extends LoginBlocState {}

class LoginSuccess extends LoginBlocState{}
class LoginError extends LoginBlocState{}


class PasswordError extends LoginBlocState{}
class PasswordSuccess extends LoginBlocState{}
class CheckUser extends LoginBlocState{}
class UserDetected extends LoginBlocState{}
class UserNotDetected extends LoginBlocState{}