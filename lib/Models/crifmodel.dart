import 'dart:convert';

CrifModel crifModelFromJson(String str) => CrifModel.fromJson(json.decode(str));

String crifModelToJson(CrifModel data) => json.encode(data.toJson());

class CrifModel {
  int statuscode;
  String message;
  List<CrifDataModel> data;

  CrifModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CrifModel.fromJson(Map<String, dynamic> json) => CrifModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<CrifDataModel>.from(json["data"].map((x) => CrifDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CrifDataModel {
  String overdueAmt;
  String writeOffAmt;
  String scoreValue;
  String combinedPaymentHistory;
  String indvTotalOtherInstallmentAmount;
  String grpTotalOtherInstallmentAmount;
  String totalOtherCurrentBalance;

  CrifDataModel({
    required this.overdueAmt,
    required this.writeOffAmt,
    required this.scoreValue,
    required this.combinedPaymentHistory,
    required this.indvTotalOtherInstallmentAmount,
    required this.grpTotalOtherInstallmentAmount,
    required this.totalOtherCurrentBalance,
  });

  factory CrifDataModel.fromJson(Map<String, dynamic> json) => CrifDataModel(
    overdueAmt: json["OVERDUE-AMT"]??"",
    writeOffAmt: json["WRITE-OFF-AMT"]??"",
    scoreValue: json["SCORE-VALUE"]??"",
    combinedPaymentHistory: json["COMBINED-PAYMENT-HISTORY"]??"",
    indvTotalOtherInstallmentAmount: json["INDV-TOTAL-OTHER-INSTALLMENT-AMOUNT"]??"",
    grpTotalOtherInstallmentAmount: json["GRP-TOTAL-OTHER-INSTALLMENT-AMOUNT"]??"",
    totalOtherCurrentBalance: json["TOTAL-OTHER-CURRENT-BALANCE"]??"",
  );

  Map<String, dynamic> toJson() => {
    "OVERDUE-AMT": overdueAmt,
    "WRITE-OFF-AMT": writeOffAmt,
    "SCORE-VALUE": scoreValue,
    "COMBINED-PAYMENT-HISTORY": combinedPaymentHistory,
    "INDV-TOTAL-OTHER-INSTALLMENT-AMOUNT": indvTotalOtherInstallmentAmount,
    "GRP-TOTAL-OTHER-INSTALLMENT-AMOUNT": grpTotalOtherInstallmentAmount,
    "TOTAL-OTHER-CURRENT-BALANCE": totalOtherCurrentBalance,
  };
}
