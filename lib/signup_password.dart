import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'DataBase/usersDB.dart';
import 'blocs/Password_bloc/password_bloc.dart';
import 'login.dart';

import 'shared_repo/prefs.dart';
import 'translator.dart';
import 'userModel.dart';
import 'userPage.dart';
import 'widgetModel/widgetModel.dart';
import 'work_with_user/insertUser/insertUser.dart';

class Password extends StatefulWidget {
  Password({Key? key, this.user}) : super(key: key);
  final User? user;
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final passwordBloc = PasswordBloc();
  final insert = InsertUser();
  final shared = SharedRepo();
  bool _hiddedPassword = true;
  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    return BlocProvider(
      create: (context) => passwordBloc,
      child: BlocListener<PasswordBloc, PasswordState>(
        listener: (context, state) {
          _listener(state);
        },
        child: BlocBuilder<PasswordBloc, PasswordState>(
          builder: (context, state) {
            return _renderPassword(state, user!);
          },
        ),
      ),
    );
  }

  Widget _renderPassword(PasswordState state, User user) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          body: Container(
              child: Column(children: [
        mySafeArea(context),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              _password1(),
              _aboutPass(),
              _password2(state, user),
            ],
          ),
        )),
        _button(user, state),
      ]))),
    );
  }

  Widget _password1() {
    return Text(
      // AppLocalizations.of(context)!.setPass,
      Translator.of(context)!.translate('setPass').toString(),
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }

  Widget _aboutPass() {
    return Text(
      // AppLocalizations.of(context)!.aboutPass,
      Translator.of(context)!.translate('aboutPass').toString(),
      style: TextStyle(color: Colors.grey[600]),
      textAlign: TextAlign.center,
    );
  }

  Widget _password2(PasswordState state, User user) {
    return FirstLast(
      margin: EdgeInsets.only(top: 15),
      text: Translator.of(context)!.translate('password').toString(),
      obscureText: _hiddedPassword,
      autofocus: false,
      validator: (password) {
        if (state is PasswordErrorState) {
          return Translator.of(context)!
              .translate('passwordErrorText')
              .toString();
        }
        return null;
      },
      readOnly: false,
      textCapitalization: TextCapitalization.sentences,
      suffix: InkWell(
        child: Text(_hiddedPassword
            ? Translator.of(context)!.translate('show').toString()
            : Translator.of(context)!.translate('hide').toString()),
        onTap: () {
          setState(() {
            _hiddedPassword = !_hiddedPassword;
          });
        },
      ),
      onChanged: (password) {
        user.password = password;
        passwordBloc.add(PasswordChanged(password!));
      },
    );
  }

  Widget _button(User user, PasswordState state) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
          onPressed: () async {
            passwordBloc.add(UserAdded(user));
          },
          child: Text(
            // AppLocalizations.of(context)!.continue1,
            Translator.of(context)!.translate('continue1').toString(),
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
              primary: state is PasswordSuccessState
                  ? Colors.blue
                  : Colors.grey[400],
              fixedSize: Size.fromWidth(250),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)))),
    );
  }

  Future<void> _listener(PasswordState state) async {
    // var prefs = await SharedPreferences.getInstance();
    if (state is UserAddedSucces) {
      await UsersDB.ins.initUser(state.user);
      //  await _realm.initData(state.user);
      await insert.initData(state.user);
      //  prefs..setString('token', state.user.createdTokenForUser.toString())
      //       ..setString('userName', state.user.username.toString());
      await shared.insertToken(
          token: state.user.createdTokenForUser.toString(),
          username: state.user.username.toString());
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => UserPage(user: state.user)));
    }
  }
}
