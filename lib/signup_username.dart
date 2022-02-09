import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/Username_bloc/username_bloc.dart';
import 'login.dart';
import 'signup_password.dart';
import 'translator.dart';
import 'userModel.dart';
import 'widgetModel/widgetModel.dart';

class UserName extends StatefulWidget {
  UserName({Key? key, this.user}) : super(key: key);
  final User? user;
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final userNameBloc = UsernameBloc();
  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    return BlocProvider(
      create: (context) => userNameBloc,
      child: BlocBuilder<UsernameBloc, UsernameState>(
        builder: (context, state) {
          return _renderUsername(state, user!);
        },
      ),
    );
  }

  Widget _renderUsername(UsernameState state, User user) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
              child: Column(children: [
            mySafeArea(context),
            Expanded(
                flex: 10,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _pickUsername(),
                      _aboutUsername(),
                      _username(state, user)
                    ],
                  ),
                )),
            //knopka
            _button(user, state)
          ]))),
    );
  }

  Widget _pickUsername() {
    return Text(
      // AppLocalizations.of(context)!.pickUsername,
      Translator.of(context)!.translate('pickUsername').toString(),
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  Widget _aboutUsername() {
    return Text(
      // AppLocalizations.of(context)!.aboutUsername,
      Translator.of(context)!.translate('aboutUsername').toString(),
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[600]),
    );
  }

  Widget _username(
    UsernameState state,
    User user,
  ) {
    return FirstLast(
      suffix: SizedBox(
        child: state is UsernameInitial
            ? null
            : state is WaitIndicator
                ? CircularProgressIndicator()
                : Container(
                    child: state is UsernameSuccessState
                        ? Icon(Icons.check)
                        : Icon(Icons.error),
                  ),
        height: 20,
        width: 20,
      ),
      obscureText: false,
      validator: (username) {
        if (state is UsernameErrorState) {
          return Translator.of(context)!.translate('usernameErrorText');
        } else if (state is UsernameUsedSate) {
          return Translator.of(context)!.translate('usernameUsedText');
        }
        return null;
      },
      margin: EdgeInsets.only(top: 15),
      text: Translator.of(context)!
          .translate('username')
          .toString()
          .toUpperCase(),
      autofocus: false,
      readOnly: false,
      textCapitalization: TextCapitalization.none,
      onChanged: (username) async {
        user.username = username;
        userNameBloc.add(UserNameChanged(username!));
      },
      helperText: state is UsernameSuccessState
          ? Translator.of(context)!.translate('usernameAvailable')
          : null,
    );
  }

  Widget _button(User user, UsernameState state) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
          onPressed: () {
            if (state is UsernameSuccessState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Password(user: user)));
            } else if (state is NotConnected) {
              showDialog(
                  context: context,
                  builder: (_) {
                    return _internetErrorAlert();
                  });
            }
          },
          child: Text(
            // AppLocalizations.of(context)!.continue1,
            Translator.of(context)!.translate('continue1').toString(),
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
              primary: state is UsernameSuccessState
                  ? Colors.blue
                  : Colors.grey[400],
              fixedSize: Size.fromWidth(250),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)))),
    );
  }

  Widget _internetErrorAlert() {
    return AlertDialog(
      title: Text('Error'),
      content: Text('Check Internet connection'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'))
      ],
    );
  }
}
