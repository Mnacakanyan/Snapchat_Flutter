part of 'countrycodeinmobile_bloc.dart';

abstract class CountrycodeinmobileState extends Equatable {
  const CountrycodeinmobileState();
  
  @override
  List<Object> get props => [];
}

class CountrycodeinmobileInitial extends CountrycodeinmobileState {}
class CountryDetected extends CountrycodeinmobileState {}
class CountryNotDetected extends CountrycodeinmobileState {}

