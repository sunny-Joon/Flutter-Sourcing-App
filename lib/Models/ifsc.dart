// To parse this JSON data, do
//
//     final ifcsc = ifcscFromJson(jsonString);

import 'dart:convert';

Ifcsc ifcscFromJson(String str) => Ifcsc.fromJson(json.decode(str));

String ifcscToJson(Ifcsc data) => json.encode(data.toJson());

class Ifcsc {
  String contact;
  String iso3166;
  String branch;
  String city;
  String micr;
  String state;
  String centre;
  bool upi;
  bool imps;
  bool rtgs;
  bool neft;
  dynamic swift;
  String address;
  String district;
  String bank;
  String bankcode;
  String ifsc;

  Ifcsc({
    required this.contact,
    required this.iso3166,
    required this.branch,
    required this.city,
    required this.micr,
    required this.state,
    required this.centre,
    required this.upi,
    required this.imps,
    required this.rtgs,
    required this.neft,
    required this.swift,
    required this.address,
    required this.district,
    required this.bank,
    required this.bankcode,
    required this.ifsc,
  });

  factory Ifcsc.fromJson(Map<String, dynamic> json) => Ifcsc(
    contact: json["CONTACT"],
    iso3166: json["ISO3166"],
    branch: json["BRANCH"],
    city: json["CITY"],
    micr: json["MICR"],
    state: json["STATE"],
    centre: json["CENTRE"],
    upi: json["UPI"],
    imps: json["IMPS"],
    rtgs: json["RTGS"],
    neft: json["NEFT"],
    swift: json["SWIFT"],
    address: json["ADDRESS"],
    district: json["DISTRICT"],
    bank: json["BANK"],
    bankcode: json["BANKCODE"],
    ifsc: json["IFSC"],
  );

  Map<String, dynamic> toJson() => {
    "CONTACT": contact,
    "ISO3166": iso3166,
    "BRANCH": branch,
    "CITY": city,
    "MICR": micr,
    "STATE": state,
    "CENTRE": centre,
    "UPI": upi,
    "IMPS": imps,
    "RTGS": rtgs,
    "NEFT": neft,
    "SWIFT": swift,
    "ADDRESS": address,
    "DISTRICT": district,
    "BANK": bank,
    "BANKCODE": bankcode,
    "IFSC": ifsc,
  };
}
