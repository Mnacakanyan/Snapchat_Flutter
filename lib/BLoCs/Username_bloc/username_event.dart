part of 'username_bloc.dart';

abstract class UsernameEvent extends Equatable {
  const UsernameEvent();

  @override
  List<Object> get props => [];
}
class UsernameErrorEvent extends UsernameEvent{}
class UsernameSuccess extends UsernameEvent{}
class UserNameNotAvailable extends UsernameEvent{}
class UserNameChanged extends UsernameEvent{
  final String username;
  UserNameChanged(this.username);
}

class CheckInet extends UsernameEvent{}