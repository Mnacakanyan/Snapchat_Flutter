

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import 'package:snapchat_ui/validCheck.dart';

part 'name_event.dart';
part 'name_state.dart';



class NameBloc extends Bloc<SignupFirstLastNameEvent, NameState> {
  Repo repo;
  String firstName = '';
  String lastName = '';
  
  NameBloc(this.repo) : super(NameInitial()){
    on<FirstNameChange>((event,emit) {
      firstName = event.firstName;
        emit(repo.firstName(event.firstName)?FirstNameValidState(): FirstNameInvalidState());
        if(repo.firstName(firstName) && repo.lastName(lastName)){
        emit(ButtonValidState());
    }
    });
    on<LastNameChange>((event,emit){
      lastName = event.lastName;
      emit(repo.lastName(event.lastName)?LastNameValidState(): LastNameInvalidState());
      if(repo.firstName(firstName) && repo.lastName(lastName)){
      emit(ButtonValidState());
    }
    });

  }
  

  
  // @override
  
  // Stream<NameState> mapEventToState(
  //   SignupFirstLastNameEvent event,

  // ) async* {
    
  //   // if(event is FirstNameChange){
  //   //   firstName = event.firstName;
  //   //   yield ( repo.firstName(firstName))? FirstNameValidState(): FirstNameInvalidState();
        
  //   // }
  //   if(event is LastNameChange){
  //     lastName = event.lastName;
  //     yield ( repo.lastName(lastName))? LastNameValidState(): LastNameInvalidState();

  //   }

    
  //   if (repo.firstName(firstName) && repo.lastName(lastName)){
      
  //     yield ButtonValidState();

  //   }
  // }
  
}

// class ButtonEvents extends NameState{
//    NameState? state_1;
//    NameState? state2;
//   ButtonEvents({this.state_1, this.state2});
// }

// class ButtonBloc extends Bloc<ButtonEvents, ButtonState>{
//   ButtonBloc() : super(ButtonInitial());
//   Color? color = Colors.grey[400];
//   ButtonEvents myBloc = ButtonEvents();
//   @override
//   Stream<ButtonState> mapEventToState(ButtonEvents event) async*{
//     if (myBloc.state_1 is NameSuccessState &&  myBloc.state2 is LastNameSuccessState){
//       yield ButtonSuccessState(Colors.blue);
//       color = Colors.blue;
//     }else{
//       ButtonErrorState(Colors.grey[400]);
//       color = Colors.grey[400];   
//     }
//   }
  
// }

// abstract class ButtonState extends Equatable{

//   @override
//   List<Object?> get props => [];
  
// }
//  class ButtonInitial extends ButtonState{

// }

//  class ButtonErrorState extends ButtonState{
//    Color? color;
//   ButtonErrorState(this.color);

//  }

//  class ButtonSuccessState extends ButtonState{
//    @override
//   Color? color;
//   ButtonSuccessState(this.color);

//  }
