// To parse this JSON data, do
//
//     final emudramodel = emudramodelFromJson(jsonString);

import 'dart:convert';

Emudramodel emudramodelFromJson(String str) => Emudramodel.fromJson(json.decode(str));

String emudramodelToJson(Emudramodel data) => json.encode(data.toJson());

class Emudramodel {
  int statuscode;
  String message;
  emudradatamodel data;

  Emudramodel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory Emudramodel.fromJson(Map<String, dynamic> json) => Emudramodel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: emudradatamodel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data.toJson(),
  };
}

class emudradatamodel {
  String message;
  String gatewayUrl;
  String txnRef;
  String esignReturn;
  String txnId;
  String responseCode;

  emudradatamodel({
    required this.message,
    required this.gatewayUrl,
    required this.txnRef,
    required this.esignReturn,
    required this.txnId,
    required this.responseCode,
  });

  factory emudradatamodel.fromJson(Map<String, dynamic> json) => emudradatamodel(
    message: json["message"]??"",
    gatewayUrl: json["gatewayURL"]??"",
    txnRef: json["txnRef"]??"",
    esignReturn: json["esignReturn"]??"",
    txnId: json["txnId"]??"",
    responseCode: json["responseCode"]??"",
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "gatewayURL": gatewayUrl,
    "txnRef": txnRef,
    "esignReturn": esignReturn,
    "txnId": txnId,
    "responseCode": responseCode,
  };
}
