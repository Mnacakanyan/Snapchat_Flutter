part of 'editpagebirthday_bloc.dart';

abstract class EditpagebirthdayEvent extends Equatable {
  const EditpagebirthdayEvent();

  @override
  List<Object> get props => [];
}
class Changed extends EditpagebirthdayEvent{}