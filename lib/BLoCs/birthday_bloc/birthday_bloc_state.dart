part of 'birthday_bloc_bloc.dart';

abstract class BirthdayBlocState extends Equatable {
  const BirthdayBlocState();
  
  @override
  List<Object> get props => [];
}

class BirthdayBlocInitial extends BirthdayBlocState {}
class BirthdayErrorState extends BirthdayBlocState {}
class BirthdaySuccessState extends BirthdayBlocState {}
