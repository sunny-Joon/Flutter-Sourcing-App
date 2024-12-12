// To parse this JSON data, do
//
//     final commonIntModel = commonIntModelFromJson(jsonString);

import 'dart:convert';

CommonBoolModel commonIntModelFromJson(String str) => CommonBoolModel.fromJson(json.decode(str));

String commonIntModelToJson(CommonBoolModel data) => json.encode(data.toJson());

class CommonBoolModel {
  int statuscode;
  String message;
  bool data;

  CommonBoolModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CommonBoolModel.fromJson(Map<String, dynamic> json) => CommonBoolModel(
    statuscode: json["statuscode"]??"",
    message: json["message"]??"",
    data: json["data"]??false,
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data,
  };
}
