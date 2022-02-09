// ignore_for_file: must_be_immutable

part of 'userpage_bloc.dart';

abstract class UserpageState extends Equatable {
  const UserpageState();
  
  @override
  List<Object> get props => [];
}

class UserpageInitial extends UserpageState {}
class EditButtonClicked extends UserpageState{
  final User? user;
  final String? token;
  EditButtonClicked(this.user, this.token);
}
class DeleteButtonClicked extends UserpageState{}
class LogoutButtonClicked extends UserpageState{}

class InfoFromMongo extends UserpageState{}
class InfoFromApi extends UserpageState{
  User? user;
  InfoFromApi({this.user});
}