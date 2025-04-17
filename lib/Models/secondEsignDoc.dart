// To parse this JSON data, do
//
//     final secondEsignDoc = secondEsignDocFromJson(jsonString);

import 'dart:convert';

SecondEsignDocModel secondEsignDocFromJson(String str) => SecondEsignDocModel.fromJson(json.decode(str));

String secondEsignDocToJson(SecondEsignDocModel data) => json.encode(data.toJson());

class SecondEsignDocModel {
  int statuscode;
  String message;
  SecondEsignDocDataModel data;

  SecondEsignDocModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory SecondEsignDocModel.fromJson(Map<String, dynamic> json) => SecondEsignDocModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: SecondEsignDocDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data.toJson(),
  };
}

class SecondEsignDocDataModel {
  String fileData;
  String creator;
  String fileUrl;
  String fiCode;

  SecondEsignDocDataModel({
    required this.fileData,
    required this.creator,
    required this.fileUrl,
    required this.fiCode,
  });

  factory SecondEsignDocDataModel.fromJson(Map<String, dynamic> json) => SecondEsignDocDataModel(
    fileData: json["fileData"]??"",
    creator: json["creator"]??"",
    fileUrl: json["fileUrl"]??"",
    fiCode: json["fiCode"]??"",
  );

  Map<String, dynamic> toJson() => {
    "fileData": fileData,
    "creator": creator,
    "fileUrl": fileUrl,
    "fiCode": fiCode,
  };
}
