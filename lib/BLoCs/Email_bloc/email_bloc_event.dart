part of 'email_bloc_bloc.dart';

abstract class EmailBlocEvent extends Equatable {
  const EmailBlocEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends EmailBlocEvent {
  final String email;
  EmailChanged(this.email);
}

class PhoneChanged extends EmailBlocEvent {
  final String? phone;
  final String? numberLength;
  PhoneChanged({this.phone, this.numberLength});
}

class EmailError extends EmailBlocEvent {}

class EmailSuccess extends EmailBlocEvent {}

class CheckInet extends EmailBlocEvent {}

class LoadCountryList extends EmailBlocEvent {}

class DetectCountry extends EmailBlocEvent {
  final BuildContext? context;
  DetectCountry(this.context);
}
