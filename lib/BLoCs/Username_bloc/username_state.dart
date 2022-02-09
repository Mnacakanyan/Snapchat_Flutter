part of 'username_bloc.dart';

abstract class UsernameState extends Equatable {
  UsernameState();

  @override
  List<Object> get props => [];
}

class UsernameInitial extends UsernameState {}

class UsernameErrorState extends UsernameState {
  UsernameErrorState();
}

class UsernameSuccessState extends UsernameState {}

class UsernameUsedSate extends UsernameState {}

class Connected extends UsernameState {}

class NotConnected extends UsernameState {}

class WaitIndicator extends UsernameState {}

class IndicatorHider extends UsernameState {}
