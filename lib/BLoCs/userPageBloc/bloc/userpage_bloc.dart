import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:snapchat_ui/shared_repo/prefs.dart';
import 'package:snapchat_ui/userModel.dart';
import 'package:snapchat_ui/validationRepo.dart';
import 'package:snapchat_ui/work_with_user/deleteUser/deleteUser.dart';
import 'package:snapchat_ui/work_with_user/updateUser/updateUser.dart';

part 'userpage_event.dart';
part 'userpage_state.dart';

class UserpageBloc extends Bloc<UserpageEvent, UserpageState> {
  final validator = Validators();
  final shared = SharedRepo();
  final update = UpdateUser();
  final delete = DeleteUser();
  UserpageBloc() : super(UserpageInitial()) {
    on<WidgetRender>((event, emit) {
      emit(InfoFromMongo());
    });
    on<WidgetWithApi>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      var user = await validator.getMe(prefs.getString('token').toString());
      await update.updateMongo(user!.username.toString(), user);
      emit(InfoFromApi(user: user));
    });
    on<Edituser>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      emit(EditButtonClicked(
          await validator.getMe(prefs.getString('token').toString()),
          prefs.getString('token').toString()));
    });
    on<Deleteuser>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      var isDeleted =
          await delete.deleteUser(prefs.getString('token').toString());
      if (isDeleted) {
        await delete
            .deleteUserFromMongo(prefs.getString('userName').toString());
        await shared.clearPrefs();
        emit(DeleteButtonClicked());
      }
    });
    on<Logout>((event, emit) async {
      await shared.clearPrefs();
      emit(LogoutButtonClicked());
    });
  }

  // @override
  // Stream<UserpageState> mapEventToState(UserpageEvent event) async* {
  //   final prefs = await SharedPreferences.getInstance();
  //   if(event is WidgetRender){
  //     yield InfoFromMongo();
  //   }
  //   if(event is WidgetWithApi){
  //     var user = await validator.getMe(prefs.getString('token').toString());
  //     await update.updateMongo(user!.username.toString(), user);
  //     yield InfoFromApi(user: user);
  //   }
  //   if (event is Edituser) {
  //     yield EditButtonClicked(
  //         await validator.getMe(prefs.getString('token').toString()),
  //         prefs.getString('token').toString());
  //   }
  //   if (event is Deleteuser) {
  //     var isDeleted = await delete.deleteUser(prefs.getString('token').toString());
  //     if (isDeleted) {
  //       await delete.deleteUserFromMongo(prefs.getString('userName').toString());
  //       yield DeleteButtonClicked();
  //     }
  //   }

  //   if (event is Logout) {
  //     await shared.clearPrefs();
  //     yield LogoutButtonClicked();
  //   }
  // }
}
