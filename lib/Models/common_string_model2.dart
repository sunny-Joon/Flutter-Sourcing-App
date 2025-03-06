// To parse this JSON data, do
//
//     final commonIntModel = commonIntModelFromJson(jsonString);

import 'dart:convert';

CommonStringModel2 commonStringModelFromJson(String str) => CommonStringModel2.fromJson(json.decode(str));

String commonStringModelToJson(CommonStringModel2 data) => json.encode(data.toJson());

class CommonStringModel2 {
  int statuscode;
  String message;
  String data;

  CommonStringModel2({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CommonStringModel2.fromJson(Map<String, dynamic> json) => CommonStringModel2(
    statuscode: json["statuscode"]??0,
    message: json["message"]??"",
    data: json["data"]??"",
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data,
  };
}
