part of 'birthday_bloc_bloc.dart';

abstract class BirthdayBlocEvent extends Equatable {
  const BirthdayBlocEvent();

  @override
  List<Object> get props => [];
}
class BdaySuccess extends BirthdayBlocEvent{}
class BdayError extends BirthdayBlocEvent{}