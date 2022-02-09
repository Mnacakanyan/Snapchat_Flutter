part of 'userpage_bloc.dart';

abstract class UserpageEvent extends Equatable {
  const UserpageEvent();

  @override
  List<Object> get props => [];
}
class Edituser extends UserpageEvent{}
class Deleteuser extends UserpageEvent{}
class Logout extends UserpageEvent{}

class WidgetRender extends UserpageEvent{
  final String? firstText;
  final String? secondText;
  WidgetRender({this.firstText, this.secondText});
}
class WidgetWithApi extends UserpageEvent{}