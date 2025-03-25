// To parse this JSON data, do
//
//     final emudramodel = emudramodelFromJson(jsonString);

import 'dart:convert';

emudramodel emudramodelFromJson(String str) => emudramodel.fromJson(json.decode(str));

String emudramodelToJson(emudramodel data) => json.encode(data.toJson());

class emudramodel {
  String message;
  String gatewayUrl;
  String txnref;
  String esignretrun;
  String txnid;
  String responseCode;

  emudramodel({
    required this.message,
    required this.gatewayUrl,
    required this.txnref,
    required this.esignretrun,
    required this.txnid,
    required this.responseCode,
  });

  factory emudramodel.fromJson(Map<String, dynamic> json) => emudramodel(
    message: json["message"],
    gatewayUrl: json["gatewayURL"],
    txnref: json["txnref"],
    esignretrun: json["esignretrun"],
    txnid: json["txnid"],
    responseCode: json["responseCode"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "gatewayURL": gatewayUrl,
    "txnref": txnref,
    "esignretrun": esignretrun,
    "txnid": txnid,
    "responseCode": responseCode,
  };
}
