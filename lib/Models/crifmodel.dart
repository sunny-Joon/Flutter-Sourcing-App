// To parse this JSON data, do
//
//     final statusModel = statusModelFromJson(jsonString);

import 'dart:convert';

CrifModel statusModelFromJson(String str) => CrifModel.fromJson(json.decode(str));

String statusModelToJson(CrifModel data) => json.encode(data.toJson());

class CrifModel {
  int statuscode;
  String message;
  CrifDataModel data;

  CrifModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CrifModel.fromJson(Map<String, dynamic> json) => CrifModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: CrifDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data.toJson(),
  };
}

class CrifDataModel {
  List<String> messageTable;
  List<MsgData> data;

  CrifDataModel({
    required this.messageTable,
    required this.data,
  });

  factory CrifDataModel.fromJson(Map<String, dynamic> json) => CrifDataModel(
    messageTable: List<String>.from(json["messageTable"].map((x) => x)),
    data: List<MsgData>.from(json["data"].map((x) => MsgData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "messageTable": List<dynamic>.from(messageTable.map((x) => x)),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MsgData {
  String overdueAmt;
  String writeOffAmt;
  String scoreValue;
  String combinedPaymentHistory;
  String indvTotalOtherInstallmentAmount;
  String grpTotalOtherInstallmentAmount;
  String totalOtherCurrentBalance;
  String Msg;


  MsgData({
    required this.overdueAmt,
    required this.writeOffAmt,
    required this.scoreValue,
    required this.combinedPaymentHistory,
    required this.indvTotalOtherInstallmentAmount,
    required this.grpTotalOtherInstallmentAmount,
    required this.totalOtherCurrentBalance,
    required this.Msg
  });

  factory MsgData.fromJson(Map<String, dynamic> json) => MsgData(
    overdueAmt: json["OVERDUE-AMT"],
    writeOffAmt: json["WRITE-OFF-AMT"],
    scoreValue: json["SCORE-VALUE"],
    combinedPaymentHistory: json["COMBINED-PAYMENT-HISTORY"],
    indvTotalOtherInstallmentAmount: json["INDV-TOTAL-OTHER-INSTALLMENT-AMOUNT"],
    grpTotalOtherInstallmentAmount: json["GRP-TOTAL-OTHER-INSTALLMENT-AMOUNT"],
    totalOtherCurrentBalance: json["TOTAL-OTHER-CURRENT-BALANCE"],
    Msg: json["Msg"],
  );

  Map<String, dynamic> toJson() => {
    "OVERDUE-AMT": overdueAmt,
    "WRITE-OFF-AMT": writeOffAmt,
    "SCORE-VALUE": scoreValue,
    "COMBINED-PAYMENT-HISTORY": combinedPaymentHistory,
    "INDV-TOTAL-OTHER-INSTALLMENT-AMOUNT": indvTotalOtherInstallmentAmount,
    "GRP-TOTAL-OTHER-INSTALLMENT-AMOUNT": grpTotalOtherInstallmentAmount,
    "TOTAL-OTHER-CURRENT-BALANCE": totalOtherCurrentBalance,
    "Msg": Msg
  };
}
