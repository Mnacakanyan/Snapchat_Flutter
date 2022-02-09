// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_ui/DataBase/db.dart';
import 'package:snapchat_ui/json/countryModel.dart';
import 'package:snapchat_ui/validCheck.dart';
import 'package:snapchat_ui/validationRepo.dart';

part 'editpage_event.dart';
part 'editpage_state.dart';

class EditpageBloc extends Bloc<EditpageEvent, EditpageState> {
  var repo = Repo();
  bool isValid = false;
  bool isValidPhone = false;
  bool isValidUsername = false;
  var validator = Validators();
  EditpageBloc() : super(EditpageInitial()) {
    on<DetectCountries>((event, emit) async {
      var countryList = await DBProvider.db.getAllCountries();
      emit(ListLoaded(countryList));
    });
    on<FirstChanged>((event, emit) {
      emit(repo.firstName(event.firstName)
          ? FirstChangedSuccess()
          : FirstChangedError());
    });
    on<PasswordChanged>((event, emit) {
      emit(repo.password(event.password)
          ? PasswordChangedSuccess()
          : PasswordChangedError());
    });
    on<EmailChanged>((event, emit) async {
      isValid = await validator.checkEmail(event.email);
      emit(isValid && repo.email(event.email)
          ? EmailChangedSuccess()
          : EmailChangedError());
    });
    on<LastChanged>((event, emit) {
      emit(repo.lastName(event.lastName)
          ? LastChangedSuccess()
          : LastChangedError());
    });
    on<PhoneChanged>((event, emit) async {
      isValidPhone = await validator.checkPhone(event.phone!);
      emit(isValidPhone && event.numberLength!.length == event.phone!.length
          ? PhoneChangedSuccess()
          : PhoneChangedError());
    });
    on<UsernameChanged>((event, emit) async {
      isValidUsername = await validator.checkUsername(event.username);
      var username1 = repo.username(event.username);
      if (isValid && username1) {
        emit(UsernameChangedSuccess());
      } else if (!username1) {
        emit(UsernameChangedError());
      } else {
        emit(UsernameUsed());
      }
    });
    on<SaveButtonClicked>((event, emit) {
      emit(UserCanChanged());
    });
  }

  // @override
  // Stream<EditpageState> mapEventToState(EditpageEvent event) async* {
  //   if (event is FirstChanged) {
  //     yield repo.firstName(event.firstName)
  //         ? FirstChangedSuccess()
  //         : FirstChangedError();
  //   }
  //   if (event is PasswordChanged) {
  //     yield repo.password(event.password)
  //         ? PasswordChangedSuccess()
  //         : PasswordChangedError();
  //   }
  //   if (event is EmailChanged) {
  //     isValid = await validator.checkEmail(event.email);
  //     yield (isValid && repo.email(event.email))
  //         ? EmailChangedSuccess()
  //         : EmailChangedError();
  //   }
  //   if (event is LastChanged) {
  //     yield repo.lastName(event.lastName)
  //         ? LastChangedSuccess()
  //         : LastChangedError();
  //   }
  //   if (event is PhoneChanged) {
  //     isValidPhone = await validator.checkPhone(event.phone!);
  //     yield (isValidPhone && event.numberLength!.length == event.phone!.length)
  //         ? PhoneChangedSuccess()
  //         : PhoneChangedError();
  //   }
  //   if (event is UsernameChanged) {
  //     isValidUsername = await validator.checkUsername(event.username);
  //     var username1 = repo.username(event.username);
  //     if (isValid && username1) {
  //       yield UsernameChangedSuccess();
  //     } else if (!username1) {
  //       yield UsernameChangedError();
  //     } else {
  //       yield UsernameUsed();
  //     }
  //   }
  //   if (event is SaveButtonClicked) {
  //     yield UserCanChanged();
  //   }
  // }
}
