// To parse this JSON data, do
//
//     final globalModel2 = globalModel2FromJson(jsonString);

import 'dart:convert';

GlobalModel2 globalModel2FromJson(String str) => GlobalModel2.fromJson(json.decode(str));

String globalModel2ToJson(GlobalModel2 data) => json.encode(data.toJson());

class GlobalModel2 {
  int statuscode;
  String message;
  Data data;

  GlobalModel2({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory GlobalModel2.fromJson(Map<String, dynamic> json) => GlobalModel2(
    statuscode: json["statuscode"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int fiId;
  String errormsg;
  bool isvalid;
  dynamic financialStatus;
  dynamic fiCode;
  String appLink;

  Data({
    required this.fiId,
    required this.errormsg,
    required this.isvalid,
    required this.financialStatus,
    required this.fiCode,
    required this.appLink,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    fiId: json["fi_Id"],
    errormsg: json["errormsg"],
    isvalid: json["isvalid"],
    financialStatus: json["financialStatus"],
    fiCode: json["fiCode"],
    appLink: json["appLink"],
  );

  Map<String, dynamic> toJson() => {
    "fi_Id": fiId,
    "errormsg": errormsg,
    "isvalid": isvalid,
    "financialStatus": financialStatus,
    "fiCode": fiCode,
    "appLink": appLink,
  };
}
