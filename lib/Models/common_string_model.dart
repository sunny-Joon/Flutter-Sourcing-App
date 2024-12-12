// To parse this JSON data, do
//
//     final commonIntModel = commonIntModelFromJson(jsonString);

import 'dart:convert';

CommonStringModel commonStringModelFromJson(String str) => CommonStringModel.fromJson(json.decode(str));

String commonStringModelToJson(CommonStringModel data) => json.encode(data.toJson());

class CommonStringModel {
  int statuscode;
  String message;
  String data;

  CommonStringModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CommonStringModel.fromJson(Map<String, dynamic> json) => CommonStringModel(
    statuscode: json["code"]??0,
    message: json["message"]??"",
    data: json["data"]??"",
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data,
  };
}
