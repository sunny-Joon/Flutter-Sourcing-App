// To parse this JSON data, do
//
//     final docsVerify = docsVerifyFromJson(jsonString);

import 'dart:convert';

DocsVerify docsVerifyFromJson(String str) => DocsVerify.fromJson(json.decode(str));

String docsVerifyToJson(DocsVerify data) => json.encode(data.toJson());

class DocsVerify {
  DocsVerifyData data;
  String status;
  int statusCode;
  int responseCode;
  String messageCode;
  String message;
  int timestamp;
  dynamic error;
  bool success;
  int count;
  String txnId;

  DocsVerify({
    required this.data,
    required this.status,
    required this.statusCode,
    required this.responseCode,
    required this.messageCode,
    required this.message,
    required this.timestamp,
    required this.error,
    required this.success,
    required this.count,
    required this.txnId,
  });

  factory DocsVerify.fromJson(Map<String, dynamic> json) => DocsVerify(
    data: DocsVerifyData.fromJson(json["data"]),
    status: json["status"],
    statusCode: json["status_code"],
    responseCode: json["response_code"],
    messageCode: json["message_code"],
    message: json["message"],
    timestamp: json["timestamp"],
    error: json["error"],
    success: json["success"],
    count: json["count"]??0,
    txnId: json["txn_id"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status": status,
    "status_code": statusCode,
    "response_code": responseCode,
    "message_code": messageCode,
    "message": message,
    "timestamp": timestamp,
    "error": error,
    "success": success,
    "count": count,
    "txn_id": txnId,
  };
}

class DocsVerifyData {
  String clientId;
  bool accountExists;
  dynamic upiId;
  String fullName;
  dynamic remarks;

  DocsVerifyData({
    required this.clientId,
    required this.accountExists,
    this.upiId,
    required this.fullName,
    this.remarks,
  });

  factory DocsVerifyData.fromJson(Map<String, dynamic> json) => DocsVerifyData(
    clientId: json["client_id"]??"",
    accountExists: json["account_exists"]??false,
    upiId: json["upi_id"]??"",
    fullName: json["full_name"]??"",
    remarks: json["remarks"]??"",
  );

  Map<String, dynamic> toJson() => {
    "client_id": clientId,
    "account_exists": accountExists,
    "upi_id": upiId,
    "full_name": fullName,
    "remarks": remarks,
  };
}
