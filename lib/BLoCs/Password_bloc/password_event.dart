part of 'password_bloc.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}
class PasswordErrorEvent extends PasswordEvent{}
class PasswordSuccessEvent extends PasswordEvent{}

class PasswordChanged extends PasswordEvent {
  final String password;
  PasswordChanged(this.password);
}
class UserAdded extends PasswordEvent{
  final User user;
  UserAdded(this.user);
}