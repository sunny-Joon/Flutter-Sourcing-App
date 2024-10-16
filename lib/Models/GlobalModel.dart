// To parse this JSON data, do
//
//     final globalModel = globalModelFromJson(jsonString);

import 'dart:convert';

GlobalModel globalModelFromJson(String str) => GlobalModel.fromJson(json.decode(str));

String globalModelToJson(GlobalModel data) => json.encode(data.toJson());

class GlobalModel {
  int statusCode;
  String message;
  int data;

  GlobalModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory GlobalModel.fromJson(Map<String, dynamic> json) => GlobalModel(
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "data": data,
  };
}
