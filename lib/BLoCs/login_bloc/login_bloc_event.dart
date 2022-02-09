part of 'login_bloc_bloc.dart';

abstract class LoginBlocEvent extends Equatable {
  const LoginBlocEvent();

  @override
  List<Object> get props => [];
}
class UsernameChanged extends LoginBlocEvent{
  final String userName;
  UsernameChanged(this.userName);
}
class PasswordChanged extends LoginBlocEvent{
  final String password;
  PasswordChanged(this.password);
}
class AllChanged extends LoginBlocEvent{}
class ButtonClicked extends LoginBlocEvent{
  final String login;
  final String password;
  ButtonClicked(this.login, this.password);
}

