part of 'editpage_bloc.dart';

abstract class EditpageEvent extends Equatable {
  const EditpageEvent();

  @override
  List<Object> get props => [];
}

class FirstChanged extends EditpageEvent {
  final String firstName;
  FirstChanged(this.firstName);
}

class PasswordChanged extends EditpageEvent {
  final String password;
  PasswordChanged(this.password);
}

class EmailChanged extends EditpageEvent {
  final String email;
  EmailChanged(this.email);
}

class LastChanged extends EditpageEvent {
  final String lastName;
  LastChanged(this.lastName);
}

class PhoneChanged extends EditpageEvent {
  final String? phone;
  final String? numberLength;
  PhoneChanged({this.phone, this.numberLength});
}

class UsernameChanged extends EditpageEvent {
  final String username;
  UsernameChanged(this.username);
}

class SaveButtonClicked extends EditpageEvent {}

class DetectCountries extends EditpageEvent {}
