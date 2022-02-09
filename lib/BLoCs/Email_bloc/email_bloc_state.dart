part of 'email_bloc_bloc.dart';

abstract class EmailBlocState extends Equatable {
  const EmailBlocState();

  @override
  List<Object> get props => [];
}

class EmailBlocInitial extends EmailBlocState {}

class EmailErrorState extends EmailBlocState {}

class EmailSuccessState extends EmailBlocState {}

class PhoneErrorState1 extends EmailBlocState {}

class PhoneSuccessState1 extends EmailBlocState {}

class NotConnected extends EmailBlocState {}

class Connected extends EmailBlocState {}

class WaitIndicator extends EmailBlocState {}

class CountryListLoaded extends EmailBlocState {
  final List<Country>? list;
  CountryListLoaded(this.list);
}

class LocationDetected extends EmailBlocState {
  final List<dynamic>? location;
  LocationDetected(this.location);
}

class IndicatorHider extends EmailBlocState {}
