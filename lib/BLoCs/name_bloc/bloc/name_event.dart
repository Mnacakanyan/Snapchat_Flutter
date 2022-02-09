part of 'name_bloc.dart';

abstract class SignupFirstLastNameEvent extends Equatable {
  const SignupFirstLastNameEvent();

  @override
  List<Object> get props => [];
}
class FirstNameChange extends SignupFirstLastNameEvent{
  final String firstName;
  FirstNameChange({required this.firstName});
}

class LastNameChange extends SignupFirstLastNameEvent{
  final String lastName;
  LastNameChange({required this.lastName});
}

