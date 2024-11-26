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
  String financialStatus;
  int fiCode;
  bool isvalide;

  GlobalDataModel({
    required this.fiId,
    required this.errormsg,
    required this.isvalide,
    required this.financialStatus,
    required this.fiCode,
  });

  factory GlobalDataModel.fromJson(Map<String, dynamic> json) => GlobalDataModel(
    fiId: json["fi_Id"]??0,
    errormsg: json["errormsg"]??"",
    isvalide: json["isvalide"],
    financialStatus: json["financialStatus"]??"",
    fiCode: json["fiCode"]??0,
  );

  Map<String, dynamic> toJson() => {
    "fi_Id": fiId,
    "errormsg": errormsg,
    "isvalide": isvalide,
    "fiCode": fiCode,
    "financialStatus": financialStatus,
  };
}
