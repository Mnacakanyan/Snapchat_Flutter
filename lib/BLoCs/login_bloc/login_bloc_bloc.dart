
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_ui/validCheck.dart';
import 'package:snapchat_ui/validationRepo.dart';

part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  Repo repo = Repo();
  var validator = Validators();
  LoginBloc() : super(LoginBlocInitial()){
    on<UsernameChanged>((event, emit){
      emit(repo.firstName(event.userName)?LoginSuccess():LoginError());
    });
    on<PasswordChanged>((event, emit){
      emit(repo.firstName(event.password)?PasswordSuccess():PasswordError());
    });
    on<ButtonClicked>((event, emit)async{
      emit(await validator.signIn(event.login, event.password)!=null?UserDetected():UserNotDetected());
    });

  }

  // @override
  // Stream<LoginBlocState> mapEventToState(
  //   LoginBlocEvent event,
  // ) async* {
  //   if(event is UsernameChanged){
  //     yield (repo.firstName(event.userName))?LoginSuccess():LoginError();
  //   }
  //   if(event is PasswordChanged){
  //     yield (repo.password(event.password))?PasswordSuccess():PasswordError();
  //   }
  //   if(event is ButtonClicked){
  //     yield (await validator.signIn(event.login, event.password))!=null?UserDetected():UserNotDetected();

  //   }

  // }
}
