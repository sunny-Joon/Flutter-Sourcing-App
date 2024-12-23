// To parse this JSON data, do
//
//     final bankNamesModel = bankNamesModelFromJson(jsonString);

import 'dart:convert';

BankNamesModel bankNamesModelFromJson(String str) => BankNamesModel.fromJson(json.decode(str));

String bankNamesModelToJson(BankNamesModel data) => json.encode(data.toJson());

class BankNamesModel {
  int statuscode;
  String message;
  List<BankNamesDataModel> data;

  BankNamesModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory BankNamesModel.fromJson(Map<String, dynamic> json) => BankNamesModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<BankNamesDataModel>.from(json["data"].map((x) => BankNamesDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BankNamesDataModel {
  int id;
  String bankName;
  String fullNameBank;
  bool isActive;

  BankNamesDataModel({
    required this.id,
    required this.bankName,
    required this.isActive,
    required this.fullNameBank,
  });

  factory BankNamesDataModel.fromJson(Map<String, dynamic> json) => BankNamesDataModel(
    id: json["id"],
    bankName: json["bankName"],
    isActive: json["isActive"],
    fullNameBank: json["fullNameBank"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bankName": bankName,
    "isActive": isActive,
    "fullNameBank": fullNameBank,
  };
}
