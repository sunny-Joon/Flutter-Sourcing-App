// To parse this JSON data, do
//
//     final commonIntModel = commonIntModelFromJson(jsonString);

import 'dart:convert';

CommonIntModel commonIntModelFromJson(String str) => CommonIntModel.fromJson(json.decode(str));

String commonIntModelToJson(CommonIntModel data) => json.encode(data.toJson());

class CommonIntModel {
  int statuscode;
  String message;
  int data;

  CommonIntModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CommonIntModel.fromJson(Map<String, dynamic> json) => CommonIntModel(
    statuscode: json["statuscode"]??"",
    message: json["message"]??"",
    data: json["data"]??0,
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data,
  };
}
