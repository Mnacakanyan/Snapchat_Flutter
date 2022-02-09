part of 'countrycodeinmobile_bloc.dart';

abstract class CountrycodeinmobileEvent extends Equatable {
  const CountrycodeinmobileEvent();

  @override
  List<Object> get props => [];
}
class TextChanged extends CountrycodeinmobileEvent{
  final String text;
  TextChanged(this.text);
}