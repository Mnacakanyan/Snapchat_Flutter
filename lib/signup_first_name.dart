import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/name_bloc/bloc/name_bloc.dart';
import 'login.dart';
import 'signup_birthday.dart';
import 'translator.dart';
import 'userModel.dart';
import 'validCheck.dart';
import 'widgetModel/widgetModel.dart';

class NameField extends StatefulWidget {
  NameField({Key? key}) : super(key: key);

  @override
  _NameFieldState createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  User user = User();
  final nameFieldBloc = NameBloc(Repo());
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => nameFieldBloc,
      child: BlocBuilder<NameBloc, NameState>(
        builder: (context, state) {
          return _renderNames(state);
        },
      ),
    );
  }

  Widget _renderNames(NameState state) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          child: Column(
            children: [
              mySafeArea(context),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    CenterTitle(context),
                    _firstName(state),
                    _lastName(state),
                    _aboutPrivacy(context),
                  ],
                ),
              )),
              _button(state)
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(NameState state) {
    return Container(
        margin: EdgeInsets.only(bottom: 15),
        child: ElevatedButton(
            onPressed: () {
              if (state is ButtonValidState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BirthDay(
                              user: user,
                            )));
              }
            },
            child: Text(
                // 'Sign Up & Accept',
                // AppLocalizations.of(context)!.signUpAccept,
                Translator.of(context)!.translate('signUpAccept').toString(),
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center),
            style: ElevatedButton.styleFrom(
                primary:
                    state is ButtonValidState ? Colors.blue : Colors.grey[400],
                fixedSize: Size.fromWidth(250),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)))));
  }

  Widget _firstName(NameState state) {
    return FirstLast(
      obscureText: false,
      readOnly: false,
      validator: (str) {
        if (state is FirstNameInvalidState) {
          return Translator.of(context)!.translate('errorText1');
        }
        return null;
      },
      onChanged: (firstName) {
        user.firstName = firstName; 
        nameFieldBloc.add(FirstNameChange(firstName: firstName!));
      },
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      // text: AppLocalizations.of(context)!.firstName,
      text: Translator.of(context)!.translate('firstName'),
      margin: EdgeInsets.only(top: 20),
    );
  }

  Widget _lastName(NameState state) {
    return FirstLast(
      obscureText: false,
      readOnly: false,
      validator: (st) {
        if (nameFieldBloc.state is LastNameInvalidState) {
          return Translator.of(context)!.translate('errorText1');
        }
        return null;
      },
      onChanged: (lastName) {
        user.lastName = lastName!;
        nameFieldBloc.add(LastNameChange(lastName: lastName));
      },
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      // text: AppLocalizations.of(context)!.lastName,
      text: Translator.of(context)!.translate('lastName'),
      margin: EdgeInsets.only(top: 20),
    );
  }

  Widget _aboutPrivacy(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: RichText(
          text: TextSpan(
              text:
                  // 'By tapping Sign Up & Accept, you acknowlegde that you have read the ',
                  // AppLocalizations.of(context)!.text1,
                  Translator.of(context)!.translate('text1'),
              style: TextStyle(color: Colors.black),
              children: [
            TextSpan(
                 /*'Privace Policy',*/ 
                // AppLocalizations.of(context)!.text2,
                text: Translator.of(context)!.translate('text2'),
                style: TextStyle(color: Colors.blue)),
            TextSpan(
                text: /*' and agree to the'*/ 
                // AppLocalizations.of(context)!.text3,
                Translator.of(context)!.translate('text3'),
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: /*' Terms of Service'*/ 
                // AppLocalizations.of(context)!.text4,
                Translator.of(context)!.translate('text4'),
                style: TextStyle(color: Colors.blue)),
            TextSpan(text: '.')
          ])),
    );
  }
}

Widget CenterTitle(BuildContext context) => Center(
        child: Text(
      // "What's your name",
      // AppLocalizations.of(context)!.yourName,
      Translator.of(context)!.translate('yourName').toString(),
      style: TextStyle(fontSize: 25),
      textAlign: TextAlign.center,
    ));
