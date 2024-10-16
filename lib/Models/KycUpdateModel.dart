// To parse this JSON data, do
//
//     final kycUpdateModel = kycUpdateModelFromJson(jsonString);

import 'dart:convert';

KycUpdateModel kycUpdateModelFromJson(String str) => KycUpdateModel.fromJson(json.decode(str));

String kycUpdateModelToJson(KycUpdateModel data) => json.encode(data.toJson());

class KycUpdateModel {
  int statusCode;
  String message;
  Data data;

  KycUpdateModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory KycUpdateModel.fromJson(Map<String, dynamic> json) => KycUpdateModel(
    statusCode: json["statusCode"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String fiTag;
  String fiCreator;
  int fiCode;

  Data({
    required this.fiTag,
    required this.fiCreator,
    required this.fiCode,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    fiTag: json["fiTag"],
    fiCreator: json["fiCreator"],
    fiCode: json["fiCode"],
  );

  Map<String, dynamic> toJson() => {
    "fiTag": fiTag,
    "fiCreator": fiCreator,
    "fiCode": fiCode,
  };
}
