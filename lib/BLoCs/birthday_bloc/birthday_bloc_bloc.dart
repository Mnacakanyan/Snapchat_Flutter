

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'birthday_bloc_event.dart';
part 'birthday_bloc_state.dart';

class BirthdayBlocBloc extends Bloc<BirthdayBlocEvent, BirthdayBlocState> {
  BirthdayBlocBloc() : super(BirthdayBlocInitial()){
    on<BdaySuccess>((event, emit){
      emit(BirthdaySuccessState());
    });
    on<BdayError>((event, emit){
      emit(BirthdayErrorState());
    });
  }

  // @override
  // Stream<BirthdayBlocState> mapEventToState(
  //   BirthdayBlocEvent event,
  // ) async* {
  //   if(event is BdaySuccess){
  //     yield BirthdaySuccessState();
  //   }
  //   else if (event is BdayError){
  //     yield BirthdayErrorState();
  //   }
  // }
}
