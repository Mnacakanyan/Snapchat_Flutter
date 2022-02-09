// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import 'blocs/userPageBloc/bloc/userpage_bloc.dart';
import 'changenotifer.dart';
import 'editPage.dart';
import 'main.dart';
import 'realmDb.dart';
import 'shared_repo/prefs.dart';
import 'userModel.dart';
import 'validationRepo.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key, this.user}) : super(key: key);
  User? user;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var validator = Validators();
  final userPageBloc = UserpageBloc();
  final _realm = RealmDB();
  final shared = SharedRepo();
  var newInfo;
  bool get changedInfo {
    if (newInfo != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    userPageBloc.add(WidgetRender());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user;

    // var userToken = user?.createdTokenForUser;
    return BlocProvider(
      create: (context) => userPageBloc,
      child: BlocListener<UserpageBloc, UserpageState>(
        listener: (context, state) {
          if (state == InfoFromMongo()) {
            userPageBloc.add(WidgetWithApi());
          }
          if (state == LogoutButtonClicked()) {
            _logOutListener(state);
          }
          if (state == DeleteButtonClicked()) {
            _deleteListener(state);
          }
        },
        child: BlocBuilder<UserpageBloc, UserpageState>(
          builder: (context, state) {
            if (state is InfoFromApi) {
              user = state.user;
            }
            return state is InfoFromApi
                ? _renderUserPageApi(state.user!, state)
                : _renderUserPage(user!, state);
          },
        ),
      ),
    );
  }

  Widget _renderUserPageApi(User user, UserpageState state) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                userPageBloc.add(WidgetRender());
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.black,
              )),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _fields('First Name: ', user.firstName!),
          _fields('Last Name: ', user.lastName!),
          _fields('Email: ', user.email.toString()),
          _fields('Phone: ', user.number.toString()),
          _fields('Username: ', user.username!),
          _fields('Birtday Date: ',
              DateFormat('d MMMM yyyy').format(DateTime.parse(user.birthDay!))),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // _buttons(
                //   'Edit User',
                //   Colors.blue,
                //   state,
                //   onPressed: () {
                //     _editUser(state);
                //   },
                // ),
                _editButton(state),
                _deleteButton(state),
                _logOutButton(state),
                // _buttons(
                //   'Delete User',
                //   Colors.red,
                //   state,
                //   onPressed: () {
                //     userPageBloc.add(Deleteuser());
                //     if (state is DeleteButtonClicked) {
                //       Navigator.of(context).pop();
                //     }
                //   },
                //   textColor: Colors.black,
                // ),
                // _buttons('Log out', Colors.yellow, state, onPressed: () {
                //   userPageBloc.add(Logout());
                //   // if (state is LogoutButtonClicked) {
                //   //   Navigator.of(context)
                //   //       .pushReplacement(MaterialPageRoute(builder: (context) {
                //   //     return FirstPage();
                //   //   }));
                //   // }
                // }, textColor: Colors.black),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _renderUserPage(User user, UserpageState state) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Shimmer(
        period: const Duration(milliseconds: 1500),
        gradient: LinearGradient(
          colors: [Colors.grey[500]!, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _fields('First Name: ', user.firstName!),
            _fields('Last Name: ', user.lastName!),
            // Text('First Name: '),
            // Text('Last Name: '),
            // Text('Email: '),
            // Text('Phone: '),
            // Text('Username: '),
            // Text('Birtday Date: '),
            _fields('Email: ', user.email.toString()),
            _fields('Phone: ', user.number.toString()),
            _fields('Username: ', user.username!),
            _fields(
                'Birtday Date: ',
                DateFormat('d MMMM yyyy')
                    .format(DateTime.parse(user.birthDay!))),
            // Container(
            //   alignment: Alignment.bottomCenter,
            //   width: MediaQuery.of(context).size.width,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       _buttons(
            //         'Edit User',
            //         Colors.blue,
            //         state,
            //         onPressed: () {
            //           _editUser(state);
            //         },
            //       ),
            //       _buttons(
            //         'Delete User',
            //         Colors.red,
            //         state,
            //         onPressed: () {
            //           userPageBloc.add(Deleteuser());
            //           if (state is DeleteButtonClicked) {
            //             Navigator.of(context).pop();
            //           }
            //         },
            //         textColor: Colors.black,
            //       ),
            //       _buttons('Log out', Colors.yellow, state, onPressed: () {
            //         userPageBloc.add(Logout());
            //         if (state is LogoutButtonClicked) {
            //           Navigator.of(context)
            //               .pushReplacement(MaterialPageRoute(builder: (context) {
            //             return FirstPage();
            //           }));
            //         }
            //       }, textColor: Colors.black),
            //     ],
            //   ),
            // ),
          ]),
        ),
      ),
    );
  }

  Widget _fields(
    String text,
    String? userInfoText,
  ) {
    if (userInfoText == 'null') {
      return Text(text);
    } else {
      return Text(
        text + userInfoText.toString(),
      );
    }
  }

  Widget _editButton(
    UserpageState state,
  ) {
    return TapDebouncer(onTap: () async {
      return _editUser(state);
    }, builder: (context, onTap) {
      return ElevatedButton(
        onPressed: onTap,
        child: Text(
          'Edit User',
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue)),
      );
    });
  }

  Widget _deleteButton(UserpageState state) {
    return ElevatedButton(
      onPressed: () {
        userPageBloc.add(Deleteuser());
      },
      child: Text(
        'Delete User',
        style: TextStyle(color: Colors.black),
      ),
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
    );
  }

  Widget _logOutButton(UserpageState state) {
    return ElevatedButton(
      onPressed: () {
        userPageBloc.add(Logout());
      },
      child: Text(
        'Log out',
        style: TextStyle(color: Colors.black),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.yellow)),
    );
  }

  Future<void> _editUser(UserpageState state) async {
    // var prefs = await SharedPreferences.getInstance();
    // var user =
    //     await validator.getMe(widget.user!.createdTokenForUser.toString());
    // var user = await validator.getMe(token.toString());
    // var user = await _realm.getUser(prefs.getString('userName').toString());
    var user = await _realm.getUser(await shared.getValue('userName'));
    // var loc = await location.getLocale(context);
    var loc = await validator.countriesFlag(user!.iso2Cc.toString());
    newInfo = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => ChangeCountryCode(),
                  child: EditPage(
                    myUser: user,
                    token: shared.getValue('token').toString(),
                    location: loc,
                  ),
                )));
    if (state is InfoFromApi) {
      if (changedInfo) {
        setState(() {
          widget.user = newInfo;
          state.user = newInfo;
        });
      }
    }
  }

  Future<void> _logOutListener(UserpageState state) async {
    if (state is LogoutButtonClicked) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return FirstPage();
      }));
    }
  }

  Future<void> _deleteListener(UserpageState state) async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return FirstPage();
    }));
  }
}
