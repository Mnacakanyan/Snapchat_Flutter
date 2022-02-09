import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'realmDb.dart';
import 'signup_first_name.dart';
import 'translator.dart';
import 'userModel.dart';
import 'userPage.dart';

Future<void> main() async {
  String login = '/';
  User? user1;
  var _realm = RealmDB();
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('userName');
  var currentUser;
  await RealmApp.init('application-0-tbwaj');

  if (username != null) {
    currentUser = await _realm.getUser(username);
    login = 'userPage';
    user1 = currentUser;
  }

  runApp(FirstPage(login: login, user1: user1));
}

class FirstPage extends StatefulWidget {
  final String? login;
  final User? user1;
  FirstPage({this.login, this.user1});
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => Intro(),
        'login': (context) => Login(),
        'userPage': (context) => UserPage(user: widget.user1),
      },
      initialRoute: widget.login,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        Translator.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('ru', 'RU'),
        Locale('hy', 'AM')
      ],
      //  home: Intro(),
    );
  }
}

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: Image.asset(
              'assets/snapchat1.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[400])),
                  onPressed: () {
                    /* await c.checkInet().whenComplete(() => */ Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                      Translator.of(context)!.translate('login').toString(),
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )))),
          Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[400])),
                onPressed: () {
                  /* await c.checkInet().whenComplete(() => */ Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NameField()));
                },
                child: Text(
                    // AppLocalizations.of(context)!.signUp,
                    Translator.of(context)!.translate('signUp').toString(),
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)))),
          ),
        ],
      ),
    );
  }
}
