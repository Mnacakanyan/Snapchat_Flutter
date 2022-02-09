// ignore_for_file: must_be_immutable

part of 'name_bloc.dart';

abstract class NameState extends Equatable {
  @override
  List<Object> get props => [];
 
}

class NameInitial extends NameState {}

class FirstNameValidState extends NameState{}

class FirstNameInvalidState extends NameState{}

class LastNameValidState extends NameState{}

class LastNameInvalidState extends NameState{}

class ButtonValidState extends NameInitial{}
