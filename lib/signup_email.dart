import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snapchat_ui/BLoCs/Email_bloc/email_bloc_bloc.dart';
import 'BLoCs/Email_bloc/email_bloc_bloc.dart';
import 'changenotifer.dart';
import 'filteredList.dart';
import 'locator.dart';
import 'login.dart';
import 'signup_username.dart';
import 'translator.dart';
import 'userModel.dart';
import 'validationRepo.dart';
import 'widgetModel/widgetModel.dart';

class Email extends StatefulWidget {
  Email({Key? key, this.user, this.local}) : super(key: key);
  final User? user;
  final List? local;
  @override
  EmailState createState() => EmailState();
}

class EmailState extends State<Email> {
  var emailText = TextEditingController();
  var numberText = TextEditingController();
  var validator = Validators();
  final emailBloc = EmailBloc();
  bool countryIsChanged = false;
  var changed;
  var countryListLoaded;
  bool emailPage = true;
  var notifier = ChangeCountryCode();
  var locator = MyLocator();
  var locationFromBloc;

  @override
  void initState() {
    emailBloc.add(DetectCountry(context));
    emailBloc.add(LoadCountryList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    return ChangeNotifierProvider(
      create: (context) => notifier,
      child: BlocProvider(
        create: (context) => emailBloc,
        child: BlocListener<EmailBloc, EmailBlocState>(
          bloc: emailBloc,
          listener: (context, state) {
            if (state is LocationDetected) {
              locationFromBloc = state.location;
            }
            if (state is CountryListLoaded) {
              countryListLoaded = state.list;
            }
          },
          child: BlocBuilder<EmailBloc, EmailBlocState>(
            builder: (context, state) {
              return _renderEmail(
                user!,
                state,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _renderEmail(
    User user,
    EmailBlocState state,
  ) {
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
              emailPage ? _emailText() : _phoneText(),
              emailPage ? _withPhone(state) : _withEmail(),
              emailPage
                  ? _emailField(user, state)
                  : Consumer<ChangeCountryCode>(
                      builder: (newContext, value, child) {
                        return _phoneField(user, state, newContext);
                      },
                    )
              //  _phoneField(user, state, context),
            ],
          ),
        )),
        //knopka
        _button(user, state),
      ]))),
    );
  }

  Widget _emailText() {
    return Center(
      child: Text(
        // AppLocalizations.of(context)!.email,
        Translator.of(context)!.translate('email').toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }

  Widget _phoneText() {
    return Center(
      child: Text(
        // AppLocalizations.of(context)!.number,
        Translator.of(context)!.translate('number').toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }

  Widget _withPhone(EmailBlocState state) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 15),
        child: TextButton(
            onPressed: () async {
              // var loc = Localizations.localeOf(context);
              // local = await validator.countries(loc.countryCode.toString());

              // setState(() {
              //   emailBloc.add(EmailError());
              //   emailText.clear();
              //   numberText.clear();

              // });
              emailBloc.add(CheckInet());
              if (state is NotConnected) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return _internetErrorAlert();
                    });
              } else if (state is Connected) {
                // local = await locator.getLocale(context);
                setState(() {
                  emailPage = !emailPage;
                });
              }
            },
            child: Text(
                // AppLocalizations.of(context)!.withPhone
                Translator.of(context)!.translate('withPhone').toString())));
  }

  Widget _withEmail() {
    return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 15),
        child: TextButton(
            onPressed: () {
              setState(() {
                emailBloc.add(EmailError());
                emailText.clear();
                numberText.clear();
                emailPage = !emailPage;
              });
            },
            child: Text(
                // AppLocalizations.of(context)!.withEmail
                Translator.of(context)!.translate('withEmail').toString())));
  }

  Widget _emailField(User user, EmailBlocState state) {
    return FirstLast(
      controller: emailText,
      onChanged: (email) {
        emailBloc.add(EmailChanged(email!));
        user.email = email;
        user.iso2Cc = 'AM';
        user.number = '';
      },
      validator: (email) {
        if (state is EmailErrorState) {
          return Translator.of(context)!.translate('invalidEmail');
        }
        return null;
      },
      suffix: SizedBox(
        child: state is IndicatorHider
            ? null
            : state is WaitIndicator
                ? CircularProgressIndicator()
                : Container(
                    child: state is EmailErrorState
                        ? Icon(Icons.error, color: Colors.red)
                        : Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                  ),
        width: 20,
        height: 20,
      ),
      autofocus: false,
      textCapitalization: TextCapitalization.none,
      readOnly: false,
      obscureText: false,
      text: 'EMAIL',
    );
  }

  Widget _phoneField(User user, EmailBlocState state, BuildContext context) {
    return FirstLast(
      controller: numberText,
      keyboardType: TextInputType.phone,
      validator: (number) {
        if (state is PhoneErrorState1) {
          return Translator.of(context)!.translate('invalidPhone');
        }
        return null;
      },
      onChanged: (number) {
        user.number = number;
        emailBloc.add(
            PhoneChanged(phone: number, numberLength: locationFromBloc[2]));
      },
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      readOnly: false,
      text: '',
      obscureText: false,
      helperText: Translator.of(context)!.translate('helpText').toString(),
      labelText: Translator.of(context)!.translate('mobileNumber').toString(),
      prefix: InkWell(
        child: Text(!countryIsChanged
            ? locationFromBloc[0] + '+' + locationFromBloc[1]
            : //changed[0] + '+' + changed[1],

            context.read<ChangeCountryCode>().country.iso2Cc.toString() +
                '+' +
                context.read<ChangeCountryCode>().country.e164Cc.toString()),
        onTap: () async {
          changed = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<ChangeCountryCode>.value(
                          value: notifier,
                          child: FilteredList(
                            list: countryListLoaded,
                          ))));
          if (changed != null) {
            setState(() {
              countryIsChanged = true;
              locationFromBloc[2] =
                  context.read<ChangeCountryCode>().country.example;
              user.iso2Cc = context.read<ChangeCountryCode>().country.iso2Cc;
            });
          }
        },
      ),
    );
  }

  Widget _button(User user, EmailBlocState state) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
          onPressed: () {
            emailBloc.add(CheckInet());
            setState(() {
              if (state is EmailSuccessState || state is PhoneSuccessState1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserName(user: user)));
              } else if (state is NotConnected) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return _internetErrorAlert();
                    });
              }
            });
          },
          child: Text(
            // AppLocalizations.of(context)!.continue1,
            Translator.of(context)!.translate('continue1').toString(),
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
              primary: state is EmailSuccessState || state is PhoneSuccessState1
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
