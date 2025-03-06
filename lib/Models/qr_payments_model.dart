// To parse this JSON data, do
//
//     final qrPaymentsModel = qrPaymentsModelFromJson(jsonString);

import 'dart:convert';

QrPaymentsModel qrPaymentsModelFromJson(String str) => QrPaymentsModel.fromJson(json.decode(str));

String qrPaymentsModelToJson(QrPaymentsModel data) => json.encode(data.toJson());

class QrPaymentsModel {
  int statuscode;
  String message;
  List<QrPaymentsDataModel> data;

  QrPaymentsModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory QrPaymentsModel.fromJson(Map<String, dynamic> json) => QrPaymentsModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<QrPaymentsDataModel>.from(json["data"].map((x) => QrPaymentsDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class QrPaymentsDataModel {
  int amount;
  String txnId;
  String creationDate;
  String errormsg;
  bool isvalid;

  QrPaymentsDataModel({
    required this.amount,
    required this.txnId,
    required this.creationDate,
    required this.errormsg,
    required this.isvalid,
  });

  factory QrPaymentsDataModel.fromJson(Map<String, dynamic> json) => QrPaymentsDataModel(
    amount: json["amount"],
    txnId: json["txnId"]??"",
    creationDate: json["creationDate"],
    errormsg: json["errormsg"]??"",
    isvalid: json["isvalid"]??"",
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "txnId": txnId,
    "creationDate": creationDate,
    "errormsg": errormsg,
    "isvalid": isvalid,
  };
}
