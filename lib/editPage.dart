// ignore_for_file: must_be_immutable

import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BLoCs/editPagebloc/bloc/editpage_bloc.dart';
import 'changenotifer.dart';
import 'filteredList.dart';
import 'userModel.dart';
import 'validationRepo.dart';
import 'work_with_user/updateUser/updateUser.dart';

class EditPage extends StatefulWidget {
  EditPage({Key? key, this.token, this.myUser, this.location})
      : super(key: key);
  List<dynamic>? location;
  String? token;
  User? myUser;
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  DateTime? selectedDate;
  var validator = Validators();

  final editBloc = EditpageBloc();
  var notifier = ChangeCountryCode();
  final update = UpdateUser();
  var changed;
  var loadedList;
  bool countryIsChanged = false;
  @override
  void initState() {
    editBloc.add(DetectCountries());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user1 = widget.myUser;
    var token = widget.token;

    return ChangeNotifierProvider(
      create: (context) => notifier,
      child: BlocProvider(
        create: (context) => editBloc,
        child: BlocListener<EditpageBloc, EditpageState>(
          listener: (context, state) {
            _buttonListener(state, user1!);
            if (state is ListLoaded) {
              loadedList = state.countryList;
            }
          },
          child: BlocBuilder<EditpageBloc, EditpageState>(
            builder: (context, state) {
              return _renderEditPage(user1!, token!, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _renderEditPage(User user1, String token, EditpageState state) {
    var local = widget.location;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(
                context,
              );
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _fieldFirstName(
                    user1.firstName.toString(), 'First name', user1, state),
                _fieldPassword(
                    user1.password.toString(), 'Password', user1, state),
                _fieldEmail(user1.email.toString(), 'Email', user1, state),
                _fieldLastName(
                    user1.lastName.toString(), 'Last Name', user1, state),
                _fieldPhone(
                    user1.number.toString(), 'Phone', user1, state, local!),
                _fieldUsername(
                    user1.username.toString(), 'Username', user1, state),
                TextFormField(
                  readOnly: true,
                  onTap: () {
                    setState(() {});
                  },
                  key: Key(DateFormat('d MMM yyyy')
                      .format(DateTime.parse(user1.birthDay.toString()))),
                  initialValue: DateFormat('d MMM yyyy')
                      .format(DateTime.parse(user1.birthDay.toString())),
                  decoration: InputDecoration(
                      labelText: 'Birthdate',
                      suffix: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          var picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(DateTime.now().year - 16,
                                DateTime.now().month, DateTime.now().day),
                            firstDate: DateTime(1972),
                            lastDate: DateTime(DateTime.now().year - 16,
                                DateTime.now().month, DateTime.now().day),
                          );
                          setState(() {
                            if (picked != null) {
                              user1.birthDay = picked.toString();
                            } else {
                              user1.birthDay = user1.birthDay;
                            }
                          });
                        },
                      )),
                ),
              ]),
              _submitChanges(),
              // ElevatedButton(
              //     onPressed: () async {
              //       var updatedInfo = await validator.editAccount(
              //           token,
              //           user1.firstName,
              //           user1.password,
              //           user1.email,
              //           user1.lastName,
              //           user1.number,
              //           user1.username,
              //           user1.birthDay);
              //       _realm.updateUserInfo(
              //           user1.username.toString(),
              //           User(
              //             firstName: user1.firstName,
              //             password: user1.password,
              //             email: user1.email,
              //             lastName: user1.lastName,
              //             number: user1.number,
              //             username: user1.username,
              //             birthDay: user1.birthDay,
              //           ));
              //       // await Navigator.maybePop(context, updatedInfo);
              //       Navigator.of(context).pop(updatedInfo);
              //     },
              //     child: Text('Save'))
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldFirstName(
      String initialValue, String text, User user, EditpageState state) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (_firstName) {
        editBloc.add(FirstChanged(_firstName));
        user.firstName = _firstName;
      },
      validator: (s) {
        if (state is FirstChangedError) {
          return 'At least 1 charachter';
        }
        return null;
      },
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: text,
      ),
    );
  }

  Widget _fieldPassword(
      String initialValue, String text, User user, EditpageState state) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (_password) {
        editBloc.add(PasswordChanged(_password));
        user.password = _password;
      },
      validator: (s) {
        if (state is PasswordChangedError) {
          return 'At least 8 charachters.';
        }
        return null;
      },
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: text,
      ),
    );
  }

  Widget _fieldEmail(
      String initialValue, String text, User user, EditpageState state) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (_email) {
        editBloc.add(EmailChanged(_email));
        user.email = _email;
      },
      validator: (s) {
        if (state is EmailChangedError) {
          return 'Enter valid email';
        }
        return null;
      },
      initialValue: initialValue == 'null' ? '' : initialValue,
      decoration: InputDecoration(
        labelText: text,
      ),
    );
  }

  Widget _fieldLastName(
      String initialValue, String text, User user, EditpageState state) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (s) {
        if (state is LastChangedError) {
          return 'At least 1 character';
        }
        return null;
      },
      onChanged: (_lastName) {
        editBloc.add(LastChanged(_lastName));
        user.lastName = _lastName;
      },
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: text,
      ),
    );
  }

  Widget _fieldPhone(String initialValue, String text, User user,
      EditpageState state, List local) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (s) {
        if (state is PhoneChangedError) {
          return 'Enter valid phone number';
        }
        return null;
      },
      onChanged: (_phone) {
        editBloc.add(PhoneChanged(phone: _phone, numberLength: local[2]));
        user.number = _phone;
      },
      initialValue: initialValue == 'null' ? '' : initialValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: text,
        prefix: InkWell(
          child: Text(!countryIsChanged
              ? EmojiConverter.fromAlpha2CountryCode(user.iso2Cc.toString()) +
                  user.iso2Cc.toString() +
                  '+' +
                  local[1] +
                  ' '
              : EmojiConverter.fromAlpha2CountryCode(context
                      .read<ChangeCountryCode>()
                      .country
                      .iso2Cc
                      .toString()) +
                  context.read<ChangeCountryCode>().country.iso2Cc.toString() +
                  '+' +
                  context.read<ChangeCountryCode>().country.e164Cc.toString() +
                  ' '),
          onTap: () async {
            changed = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context1) =>
                      ChangeNotifierProvider<ChangeCountryCode>.value(
                    value:
                        Provider.of<ChangeCountryCode>(context, listen: false),
                    child: FilteredList(
                      list: loadedList,
                    ),
                  ),
                ));
            setState(() {
              if (changed != null) {
                countryIsChanged = true;
                local[2] = context.read<ChangeCountryCode>().country.example;
                user.iso2Cc = context.read<ChangeCountryCode>().country.iso2Cc;
              }
            });
          },
        ),
      ),
    );
  }

  Widget _fieldUsername(
      String initialValue, String text, User user, EditpageState state) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (s) {
        if (state is UsernameChangedError) {
          return 'At least 5 charachter';
        } else if (state is UsernameUsed) {
          return 'Username already used';
        }
        return null;
      },
      onChanged: (_username) {
        editBloc.add(UsernameChanged(_username));
        user.username = _username;
      },
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: text,
      ),
    );
  }

  Widget _submitChanges() {
    return ElevatedButton(
        onPressed: () {
          editBloc.add(SaveButtonClicked());
        },
        child: Text('Save'));
  }

  Future<void> _buttonListener(EditpageState state, User user1) async {
    var prefs = await SharedPreferences.getInstance();
    if (state is UserCanChanged) {
      var updatedInfo = await update.editAccount(
          prefs.getString('token').toString(),
          user1.firstName,
          user1.password,
          user1.email,
          user1.lastName,
          user1.number,
          user1.username,
          user1.birthDay,
          user1.iso2Cc);
      await update.updateMongo(
          user1.username.toString(),
          User(
              firstName: user1.firstName,
              password: user1.password,
              email: user1.email,
              lastName: user1.lastName,
              number: user1.number,
              username: user1.username,
              birthDay: user1.birthDay,
              iso2Cc: user1.iso2Cc));
      Navigator.of(context).pop(updatedInfo);
    }
  }
}
