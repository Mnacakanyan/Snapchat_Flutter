import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_ui/userModel.dart';
import 'package:snapchat_ui/validCheck.dart';
import 'package:snapchat_ui/validationRepo.dart';
import 'package:snapchat_ui/work_with_user/insertUser/insertUser.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  Repo repo = Repo();

  var validator = Validators();
  bool isValid = false;
  final insert = InsertUser();
  PasswordBloc() : super(PasswordInitial()) {
    on<PasswordChanged>((event, emit) {
      emit(repo.password(event.password)
          ? PasswordSuccessState()
          : PasswordErrorState());
    });
    on<UserAdded>((event, emit) async {
      User? user;
      // user = (await validator.addUser(event.user));
      user = await insert.addUser(event.user);
      emit(user is User ? UserAddedSucces(user) : UserNotAdded());
    });
  }
  // @override
  // Stream<PasswordState> mapEventToState(
  //   PasswordEvent event,
  // ) async* {
  //   if(event is PasswordChanged){
  //     yield repo.password(event.password)?PasswordSuccessState():PasswordErrorState();

  //   }
  //   if(event is UserAdded){
  //     User? user;
  //     user = (await validator.addUser(event.user));
  //     // user= (await _realm.initData(event.user));
  //     yield user is User?UserAddedSucces(user):UserNotAdded();
  //   }
  // }
}
