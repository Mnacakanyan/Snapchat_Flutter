import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_ui/connectionCheck.dart';
import 'package:snapchat_ui/realmDb.dart';
import 'package:snapchat_ui/validCheck.dart';

import '../../validationRepo.dart';

part 'username_event.dart';
part 'username_state.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState> {
  UsernameBloc() : super(UsernameInitial()) {
    on<CheckInet>((event, emit) async {
      var isConnected = await inet.checkInet();
      if (isConnected) {
        emit(Connected());
      } else {
        emit(NotConnected());
      }
    });
    on<UserNameChanged>((event, emit) async {
      emit(WaitIndicator());
      username1 = repo.username(event.username);
      var isConnected = await inet.checkInet();
      if (isConnected) {
        isValid = await validator.checkUsername(event.username);
        // isValid = await realm.checkUsername(event.username);

      } else {
        emit(NotConnected());
      }

      if (isValid && username1) {
        emit(UsernameSuccessState());
      } else if (!username1) {
        emit(UsernameErrorState());
      } else {
        emit(UsernameUsedSate());
      }
    });
  }
  var validator = Validators();
  Repo repo = Repo();
  bool isValid = false;
  bool username1 = false;
  var inet = CheckInternet();
  final realm = RealmDB();
  // @override
  // Stream<UsernameState> mapEventToState(
  //   UsernameEvent event,
  // ) async* {
  //   if(event is CheckInet){
  //     var isConnected = await inet.checkInet();
  //     if(isConnected){
  //       yield Connected();
  //     }else{
  //       yield NotConnected();
  //     }
  //   }

  //   if(event is UserNameChanged){
  //     username1 = repo.username(event.username);
  //     var isConnected = await inet.checkInet();
  //     if(isConnected){
  //       isValid = await validator.checkUsername(event.username);
  //       // isValid = await realm.checkUsername(event.username);

  //     }else{
  //       yield NotConnected();
  //     }

  //     // isValid = await _realm.checkUsername(event.username);
  //   }
  //   if(isValid && username1){
  //     yield UsernameSuccessState();
  //   }else if(!username1){
  //     yield UsernameErrorState();
  //   }else{
  //     yield UsernameUsedSate();
  //   }
  //   // if(event is UsernameErrorEvent){
  //   //   yield UsernameErrorState();

  //   // }
  //   // else if(event is UsernameSuccess){
  //   //   yield UsernameSuccessState();

  //   // }
  //   // else if(event is UserNameNotAvailable){
  //   //   yield UsernameUsedSate();

  //   // }
  // }
}
