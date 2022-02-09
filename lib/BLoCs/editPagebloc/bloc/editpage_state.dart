part of 'editpage_bloc.dart';

abstract class EditpageState extends Equatable {
  const EditpageState();

  @override
  List<Object> get props => [];
}

class EditpageInitial extends EditpageState {}

class FirstChangedSuccess extends EditpageState {}

class FirstChangedError extends EditpageState {}

class PasswordChangedSuccess extends EditpageState {}

class PasswordChangedError extends EditpageState {}

class EmailChangedSuccess extends EditpageState {}

class EmailChangedError extends EditpageState {}

class LastChangedSuccess extends EditpageState {}

class LastChangedError extends EditpageState {}

class PhoneChangedSuccess extends EditpageState {}

class PhoneChangedError extends EditpageState {}

class UsernameChangedSuccess extends EditpageState {}

class UsernameChangedError extends EditpageState {}

class UsernameUsed extends EditpageState {}

class UserCanChanged extends EditpageState {}

class ListLoaded extends EditpageState {
  final List<Country> countryList;
  ListLoaded(this.countryList);
}
