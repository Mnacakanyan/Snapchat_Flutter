import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snapchat_ui/locator.dart';

import 'blocs/birthday_bloc/birthday_bloc_bloc.dart';
import 'changenotifer.dart';
import 'login.dart';
import 'signup_email.dart';
import 'translator.dart';
import 'userModel.dart';
import 'widgetModel/widgetModel.dart';

class BirthDay extends StatefulWidget {
  BirthDay({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  _BirthDayState createState() => _BirthDayState();
}

class _BirthDayState extends State<BirthDay> {
  final bdayBloc = BirthdayBlocBloc();
  MyLocator locator = MyLocator();
  DateTime? secondsOfAge;
  var text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    final _media = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => bdayBloc,
      child: BlocBuilder<BirthdayBlocBloc, BirthdayBlocState>(
        builder: (context, state) {
          return _renderBirthDay(_media, state, user!);
        },
      ),
    );
  }

  Widget _renderBirthDay(Size _media, BirthdayBlocState state, User user) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          body: Container(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
        mySafeArea(context),
        _birthdayText(),
        _birthday(context),
        _button(_media, state, user),
        _dateTimePicker(),
      ]))),
    );
  }

  Widget _birthdayText() {
    return Text(
      // "When's your birthday?",
      // AppLocalizations.of(context)!.birthDay,
      Translator.of(context)!.translate('birthDay').toString(),
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }

  Widget _birthday(BuildContext context) {
    return FirstLast(
      obscureText: false,
      onChanged: (a) {},
      readOnly: true,
      keyboardType: TextInputType.datetime,
      controller: text,
      textCapitalization: TextCapitalization.sentences,
      autofocus: false,
      text: Translator.of(context)!.translate('birth'),
    );
  }

  Widget _button(Size _media, BirthdayBlocState state, User user) {
    return Padding(
      padding: EdgeInsets.only(top: _media.height > 800 ? 340 : 103),
      child: Container(
        child: ElevatedButton(
            onPressed: () async {
              // var local = await locator.getLocale(context);
              setState(() {
                if (state is BirthdaySuccessState) {
                  user.birthDay = secondsOfAge.toString();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                            create: (context) => ChangeCountryCode(),
                            child: Email(
                              user: user,
                              // local: local,
                            ),
                          )));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ChangeNotifierProvider(
                  //           create: (context) => ChangeCountryCode(),
                  //           child: Email(user: user))));
                } else if (state is BirthdayErrorState) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _errorDialog();
                      });
                }
              });
            },
            child:
                Text(Translator.of(context)!.translate('continue1').toString()),
            style: ElevatedButton.styleFrom(
                primary: state is BirthdaySuccessState
                    ? Colors.blue
                    : Colors.grey[400],
                fixedSize: Size.fromWidth(_media.width - 200),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)))),
      ),
    );
  }

  Widget _dateTimePicker() {
    return Expanded(
      child: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          minimumDate: DateTime(1972, 1, 1),
          maximumDate: DateTime(2099, 12, 31),
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (date) {
            setState(() {
              secondsOfAge = date;
              if (date.isBefore(DateTime(DateTime.now().year - 15,
                  DateTime.now().month, DateTime.now().day))) {
                bdayBloc.add(BdaySuccess());
              } else {
                bdayBloc.add(BdayError());
              }
              text.text = DateFormat('d MMMM yyyy').format(date);
            });
          }),
    );
  }

  Widget _errorDialog() {
    return CupertinoAlertDialog(
      title: Text(
          // AppLocalizations.of(context)!.warning,
          Translator.of(context)!.translate('warning').toString(),
          style: TextStyle(fontSize: 20)),
      content: Text(
          // AppLocalizations.of(context)!.aboutAge,
          Translator.of(context)!.translate('aboutAge').toString(),
          style: TextStyle(fontSize: 18)),
      actions: [
        CupertinoDialogAction(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
