import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Translator {
  final Locale? locale;

  Translator({this.locale});
  static Translator? of(BuildContext context) {
    return Localizations.of<Translator>(context, Translator);
  }

  static const LocalizationsDelegate<Translator> delegate =
  _TranslatorDelegate();

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    String jsonString =
    await rootBundle.loadString('assets/i18n/${locale!.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }


  String? translate(String key) {
    return _localizedStrings![key];
  }
}

class _TranslatorDelegate
    extends LocalizationsDelegate<Translator> {
  const _TranslatorDelegate();

  @override
  bool isSupported(Locale locale) {

    return ['en', 'ru', 'hy', 'es', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<Translator> load(Locale locale) async {
    Translator localizations = new Translator(locale:locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_TranslatorDelegate old) => false;
}