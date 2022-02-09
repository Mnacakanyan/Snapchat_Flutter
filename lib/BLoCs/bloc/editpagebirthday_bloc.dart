import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'editpagebirthday_event.dart';
part 'editpagebirthday_state.dart';

class EditpagebirthdayBloc extends Bloc<EditpagebirthdayEvent, String?> {
  String? text;
  EditpagebirthdayBloc() : super('') {
    on<EditpagebirthdayEvent>((event, emit) {
      if(event is Changed){
        
      }
    });
  }
}
