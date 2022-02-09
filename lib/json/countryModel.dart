// To parse this JSON data, do
//
//     final country = countryFromJson(jsonString);

import 'dart:convert';

List<Country> countryFromJson(String str) =>
    List<Country>.from(json.decode(str).map((x) => Country.fromJson(x)));

String countryToJson(List<Country> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Country {
  Country({
    this.e164Cc,
    this.iso2Cc,
    this.e164Sc,
    this.geographic,
    this.level,
    this.name,
    this.example,
    this.displayName,
    this.fullExampleWithPlusSign,
    this.displayNameNoE164Cc,
    this.e164Key,
  });

  String? iso2Cc;
  String? e164Cc;
  int? e164Sc;
  bool? geographic;
  int? level;
  String? name;
  String? example;
  String? displayName;
  String? fullExampleWithPlusSign;
  String? displayNameNoE164Cc;
  String? e164Key;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        e164Cc: json['e164_cc'],
        iso2Cc: json['iso2_cc'],
        e164Sc: json['e164_sc'],
        geographic: json['geographic'],
        level: json['level'],
        name: json['name'],
        example: json['example'],
        displayName: json['display_name'],
        fullExampleWithPlusSign: json['full_example_with_plus_sign'] ?? null,
        displayNameNoE164Cc: json['display_name_no_e164_cc'],
        e164Key: json['e164_key'],
      );

  Map<String, dynamic> toJson() => {
        'e164_cc': e164Cc,
        'iso2_cc': iso2Cc,
        'e164_sc': e164Sc,
        'geographic': geographic,
        'level': level,
        'name': name,
        'example': example,
        'display_name': displayName,
        'full_example_with_plus_sign': fullExampleWithPlusSign ?? null,
        'display_name_no_e164_cc': displayNameNoE164Cc,
        'e164_key': e164Key,
      };
}
