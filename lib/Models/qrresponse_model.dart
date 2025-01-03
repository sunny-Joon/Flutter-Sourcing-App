// To parse this JSON data, do
//
//     final qrResponseModel = qrResponseModelFromJson(jsonString);

import 'dart:convert';

QrResponseModel qrResponseModelFromJson(String str) => QrResponseModel.fromJson(json.decode(str));

String qrResponseModelToJson(QrResponseModel data) => json.encode(data.toJson());

class QrResponseModel {
  int statuscode;
  String message;
  List<QrResponseDataModel> data;

  QrResponseModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory QrResponseModel.fromJson(Map<String, dynamic> json) => QrResponseModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<QrResponseDataModel>.from(json["data"].map((x) => QrResponseDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class QrResponseDataModel {
  String smCode;
  String name;
  String upITxnId;
  String ammount;
  String settlementStatus;
  String txnDateTime;
  String errormsg;
  bool isvalid;

  QrResponseDataModel({
    required this.smCode,
    required this.name,
    required this.upITxnId,
    required this.ammount,
    required this.settlementStatus,
    required this.txnDateTime,
    required this.errormsg,
    required this.isvalid,
  });

  factory QrResponseDataModel.fromJson(Map<String, dynamic> json) => QrResponseDataModel(
    smCode: json["sm_Code"]??"",
    name: json["name"]??"",
    upITxnId: json["upI_Txn_Id"]??"",
    ammount: json["ammount"]??"",
    settlementStatus: json["settlement_Status"]??"",
    txnDateTime: json["txn_DateTime"]??"",
    errormsg: json["errormsg"]??"",
    isvalid: json["isvalid"]??false,
  );

  Map<String, dynamic> toJson() => {
    "sm_Code": smCode,
    "name": name,
    "upI_Txn_Id": upITxnId,
    "ammount": ammount,
    "settlement_Status": settlementStatus,
    "txn_DateTime": txnDateTime,
    "errormsg": errormsg,
    "isvalid": isvalid,
  };
}
