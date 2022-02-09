part of 'password_bloc.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();
  
  @override
  List<Object> get props => [];
}

class PasswordInitial extends PasswordState {}
class PasswordErrorState extends PasswordState {}
class PasswordSuccessState extends PasswordState {}
class UserAddedSucces extends PasswordState{
  final User user;
  UserAddedSucces(this.user);
}
class UserNotAdded extends PasswordState{}
