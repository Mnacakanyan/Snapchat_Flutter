import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:snapchat_ui/DataBase/db.dart';

import 'package:snapchat_ui/connectionCheck.dart';
import 'package:snapchat_ui/json/countryModel.dart';
import 'package:snapchat_ui/locator.dart';
import 'package:snapchat_ui/validCheck.dart';
import 'package:snapchat_ui/validationRepo.dart';

part 'email_bloc_event.dart';
part 'email_bloc_state.dart';

class EmailBloc extends Bloc<EmailBlocEvent, EmailBlocState> {
  Repo repo = Repo();
  bool test = false;
  var validator = Validators();
  var inet = CheckInternet();
  var locator = MyLocator();
  bool isValid = false;
  bool isValidPhone = false;

  EmailBloc() : super(EmailBlocInitial()) {
    on<DetectCountry>((event, emit) async {
      var location = await locator.getLocale(event.context!);
      emit(LocationDetected(location));
      emit(IndicatorHider());
    });
    on<LoadCountryList>((event, emit) async {
      var countryList = await DBProvider.db.getAllCountries();
      emit(CountryListLoaded(countryList));
      emit(IndicatorHider());
    });
    on<EmailChanged>((event, emit) async {
      emit(WaitIndicator());
      var isConnected = await inet.checkInet();
      if (isConnected) {
        isValid = await validator.checkEmail(event.email);
        bool isValidEmail = isValid && repo.email(event.email);
        emit(isValidEmail ? EmailSuccessState() : EmailErrorState());
      } else {
        emit(NotConnected());
      }
    });
    on<EmailError>((event, emit) {
      emit(EmailErrorState());
    });
    on<PhoneChanged>((event, emit) async {
      var isConnected = await inet.checkInet();
      if (isConnected) {
        isValidPhone = await validator.checkPhone(event.phone.toString());
        emit((isValidPhone && event.numberLength!.length == event.phone!.length)
            ? PhoneSuccessState1()
            : PhoneErrorState1());
      } else {
        emit(NotConnected());
      }
    });
    on<CheckInet>((event, emit) async {
      var isConnected = await inet.checkInet();
      if (isConnected) {
        emit(Connected());
      } else {
        emit(NotConnected());
      }
    });
  }

  // @override
  // Stream<EmailBlocState> mapEventToState(
  //   EmailBlocEvent event,
  // ) async* {
  //   if(event is EmailError){
  //     yield EmailErrorState();
  //   }
  //   if(event is EmailChanged){
  //     // test = await _realm.checkEmail(event.email);
  //     var isConnected = await inet.checkInet();
  //     if(isConnected){
  //       isValid = await validator.checkEmail(event.email);
  //       yield (isValid && repo.email(event.email)) ? EmailSuccessState():EmailErrorState();
  //     }else{
  //       yield NotConnected();
  //     }

  //   }
  //   if(event is PhoneChanged){
  //     var isConnected = await inet.checkInet();
  //     if(isConnected){
  //       isValidPhone = await validator.checkPhone(event.phone.toString());
  //       yield (isValidPhone && event.numberLength!.length==event.phone!.length)?PhoneSuccessState1():PhoneErrorState1();
  //     }else{
  //       yield NotConnected();
  //     }
  //   }
  //   if(event is CheckInet){
  //     var isConnected = await inet.checkInet();
  //     if(isConnected){
  //       yield Connected();
  //     }else{
  //       yield NotConnected();
  //     }
  //   }
  // }
}
