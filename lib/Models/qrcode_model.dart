// To parse this JSON data, do
//
//     final qrCodeModel = qrCodeModelFromJson(jsonString);

import 'dart:convert';

QrCodeModel qrCodeModelFromJson(String str) => QrCodeModel.fromJson(json.decode(str));

String qrCodeModelToJson(QrCodeModel data) => json.encode(data.toJson());

class QrCodeModel {
  int statuscode;
  String message;
  List<QrCodeDataModel> data;

  QrCodeModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory QrCodeModel.fromJson(Map<String, dynamic> json) => QrCodeModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<QrCodeDataModel>.from(json["data"].map((x) => QrCodeDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class QrCodeDataModel {
  String qrCodeUrl;
  String txnId;
  String custRef;
  String virtualVpa;
  String txnDateTime;
  String errormsg;
  bool isvalid;

  QrCodeDataModel({
    required this.qrCodeUrl,
    required this.txnId,
    required this.custRef,
    required this.virtualVpa,
    required this.txnDateTime,
    required this.errormsg,
    required this.isvalid,
  });

  factory QrCodeDataModel.fromJson(Map<String, dynamic> json) => QrCodeDataModel(
    qrCodeUrl: json["qrCodeUrl"]??"",
    txnId: json["txnId"]??"",
    custRef: json["custRef"]??"",
    virtualVpa: json["virtualVpa"]??"",
    txnDateTime: json["txnDateTime"]??"",
    errormsg: json["errormsg"]??"",
    isvalid: json["isvalid"]??"",
  );

  Map<String, dynamic> toJson() => {
    "qrCodeUrl": qrCodeUrl,
    "txnId": txnId,
    "custRef": custRef,
    "virtualVpa": virtualVpa,
    "txnDateTime": txnDateTime,
    "errormsg": errormsg,
    "isvalid": isvalid,
  };
}
