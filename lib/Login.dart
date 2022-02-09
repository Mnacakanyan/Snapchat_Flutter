import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/login_bloc/login_bloc_bloc.dart';
import 'shared_repo/prefs.dart';
import 'translator.dart';
import 'userPage.dart';
import 'validationRepo.dart';
import 'widgetModel/widgetModel.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var controller = TextEditingController();
  var focusNode = FocusNode();
  bool _isHidden = false;
  final loginBloc = LoginBloc();
  final validator = Validators();
  String? username, password;
  var userToken;
  var user1;
  final shared = SharedRepo();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc,
      child: BlocListener<LoginBloc, LoginBlocState>(
        listener: (context, state) {
          _listener(state);
        },
        listenWhen: (pr, st) {
          if ((pr == PasswordSuccess() && st == UserDetected()) ||
              (pr == LoginSuccess() && st == UserDetected())) {
            return true;
          } else {
            return false;
          }
        },
        child: BlocBuilder<LoginBloc, LoginBlocState>(
          builder: (context, state) {
            return _renderLogin(state);
          },
        ),
      ),
    );
  }

  Widget _renderLogin(LoginBlocState state) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            mySafeArea(context),
            _loginText(),
            Container(
              child: Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    _usernameEmailField(state),
                    _PasswordField(state),
                    _forgotPassword()
                  ],
                ),
              )),
            ),
            _button(state),
          ],
        ),
      ),
    );
  }

  Widget _loginText() {
    return Center(
        child: Text(
      Translator.of(context)!.translate('loginPage').toString(),
      style: TextStyle(
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    ));
  }

  Widget _usernameEmailField(LoginBlocState state) {
    return FirstLast(
      margin: EdgeInsets.only(top: 20),
      autofocus: false,
      textCapitalization: TextCapitalization.none,
      readOnly: false,
      obscureText: false,
      onChanged: (login) {
        loginBloc.add(UsernameChanged(login!));
        username = login;
      },
      validator: (username) {
        if (state is LoginError) {
          return 'At least 1 character.';
        }
        return null;
      },
      text: 'USERNAME OR EMAIL',
    );
  }

  Widget _PasswordField(LoginBlocState state) {
    return FirstLast(
      validator: (login) {
        if (state is PasswordError) {
          return 'At least 8 character.';
        }
        return null;
      },
      margin: EdgeInsets.only(top: 20),
      autofocus: false,
      textCapitalization: TextCapitalization.none,
      readOnly: false,
      obscureText: !_isHidden,
      onChanged: (_password) {
        loginBloc.add(PasswordChanged(_password!));
        password = _password;
      },
      text: 'PASSWORD',
      suffix: IconButton(
        icon: _isHidden ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        onPressed: () {
          setState(() {
            _isHidden = !_isHidden;
          });
        },
      ),
    );
  }

  Widget _forgotPassword() {
    return Center(
      child: TextButton(
        child: Text(Translator.of(context)!.translate('forgotPass').toString()),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Processing...'), duration: Duration(seconds: 1)),
          );
        },
      ),
    );
  }

  Widget _button(LoginBlocState state) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
          onPressed: () {
            loginBloc.add(ButtonClicked(username!, password!));
          },
          child: Text(
            Translator.of(context)!.translate('loginPage').toString(),
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.grey[400],
              fixedSize: Size.fromWidth(250),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)))),
    );
  }

  Future<void> _listener(LoginBlocState state) async {
    // var prefs = await SharedPreferences.getInstance();
    var user = await validator.signIn(username!, password!);
    if (state is UserDetected) {
      await shared.insertToken(
          token: user!.createdTokenForUser.toString(),
          username: user.username.toString());
      // prefs..setString('token', user!.createdTokenForUser.toString())
      //      ..setString('userName', user.username.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserPage(
                    user: user,
                  )));
    }
  }
}

Widget mySafeArea(BuildContext context) => SafeArea(
      bottom: false,
      child: Container(
        alignment: Alignment.centerLeft,
        child: IconButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
    );
