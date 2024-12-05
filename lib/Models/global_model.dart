// To parse this JSON data, do
//
//     final globalModel = globalModelFromJson(jsonString);

import 'dart:convert';

GlobalModel globalModelFromJson(String str) => GlobalModel.fromJson(json.decode(str));

String globalModelToJson(GlobalModel data) => json.encode(data.toJson());

class GlobalModel {
  int statuscode;
  String message;
  List<GlobalDataModel> data;

  GlobalModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory GlobalModel.fromJson(Map<String, dynamic> json) => GlobalModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<GlobalDataModel>.from(json["data"].map((x) => GlobalDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GlobalDataModel {
  int fiId;
  String errormsg;
  bool isvalid;
  dynamic financialStatus;
  dynamic fiCode;
  dynamic appLink;


  GlobalDataModel({
    required this.fiId,
    required this.errormsg,
    required this.isvalid,
    required this.financialStatus,
    required this.fiCode,
    required this.appLink,
  });

  factory GlobalDataModel.fromJson(Map<String, dynamic> json) => GlobalDataModel(

    fiId: json["fi_Id"],
    errormsg: json["errormsg"]??"",
    isvalid: json["isvalid"],
    financialStatus: json["financialStatus"]??"",
    fiCode: json["fiCode"]??"",
    appLink: json["appLink"]??"",

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
