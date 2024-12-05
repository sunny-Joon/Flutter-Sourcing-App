// To parse this JSON data, do
//
//     final kycScanningModel = kycScanningModelFromJson(jsonString);

import 'dart:convert';

KycScanningModel kycScanningModelFromJson(String str) => KycScanningModel.fromJson(json.decode(str));

String kycScanningModelToJson(KycScanningModel data) => json.encode(data.toJson());

class KycScanningModel {
  int statuscode;
  String message;
  KycScanningDataModel data;

  KycScanningModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory KycScanningModel.fromJson(Map<String, dynamic> json) => KycScanningModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: KycScanningDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data.toJson(),
  };
}

class KycScanningDataModel {
  int fiId;
  dynamic docname;
  bool addharExists;
  dynamic aadharPath;
  int aadharCheckListId;
  dynamic aadharBPath;
  int aadharBCheckListId;
  bool voterExists;
  String voterPath;
  int voterCheckListId;
  dynamic voterBPath;
  int voterBCheckListId;
  bool panExists;
  dynamic panPath;
  int panCheckListId;
  bool drivingExists;
  dynamic drivingPath;
  int drivingCheckListId;
  bool passBookExists;
  String passBookPath;
  int passBookCheckListId;
  bool passportExists;
  int passportCheckListId;
  dynamic passportPath;
  List<GrDoc> grDocs;
  dynamic errormsg;
  dynamic isvalide;

  KycScanningDataModel({
    required this.fiId,
    required this.docname,
    required this.addharExists,
    required this.aadharPath,
    required this.aadharCheckListId,
    required this.aadharBPath,
    required this.aadharBCheckListId,
    required this.voterExists,
    required this.voterPath,
    required this.voterCheckListId,
    required this.voterBPath,
    required this.voterBCheckListId,
    required this.panExists,
    required this.panPath,
    required this.panCheckListId,
    required this.drivingExists,
    required this.drivingPath,
    required this.drivingCheckListId,
    required this.passBookExists,
    required this.passBookPath,
    required this.passBookCheckListId,
    required this.passportExists,
    required this.passportCheckListId,
    required this.passportPath,
    required this.grDocs,
    required this.errormsg,
    required this.isvalide,
  });

  factory KycScanningDataModel.fromJson(Map<String, dynamic> json) => KycScanningDataModel(
    fiId: json["fi_Id"],
    docname: json["docname"],
    addharExists: json["addharExists"]??"",
    aadharPath: json["aadharPath"]??"",
    aadharCheckListId: json["aadharCheckListId"]??"",
    aadharBPath: json["aadharBPath"]??"",
    aadharBCheckListId: json["aadharBCheckListId"]??"",
    voterExists: json["voterExists"]??"",
    voterPath: json["voterPath"]??"",
    voterCheckListId: json["voterCheckListId"]??"",
    voterBPath: json["voterBPath"]??"",
    voterBCheckListId: json["voterBCheckListId"]??"",
    panExists: json["panExists"]??"",
    panPath: json["panPath"]??"",
    panCheckListId: json["panCheckListId"]??"",
    drivingExists: json["drivingExists"]??"",
    drivingPath: json["drivingPath"]??"",
    drivingCheckListId: json["drivingCheckListId"]??"",
    passBookExists: json["passBookExists"]??"",
    passBookPath: json["passBookPath"]??"",
    passBookCheckListId: json["passBookCheckListId"]??"",
    passportExists: json["passportExists"]??"",
    passportCheckListId: json["passportCheckListId"]??"",
    passportPath: json["passportPath"]??"",
    grDocs: List<GrDoc>.from(json["grDocs"].map((x) => GrDoc.fromJson(x))),
    errormsg: json["errormsg"],
    isvalide: json["isvalide"],
  );

  Map<String, dynamic> toJson() => {
    "fi_Id": fiId,
    "docname": docname,
    "addharExists": addharExists,
    "aadharPath": aadharPath,
    "aadharCheckListId": aadharCheckListId,
    "aadharBPath": aadharBPath,
    "aadharBCheckListId": aadharBCheckListId,
    "voterExists": voterExists,
    "voterPath": voterPath,
    "voterCheckListId": voterCheckListId,
    "voterBPath": voterBPath,
    "voterBCheckListId": voterBCheckListId,
    "panExists": panExists,
    "panPath": panPath,
    "panCheckListId": panCheckListId,
    "drivingExists": drivingExists,
    "drivingPath": drivingPath,
    "drivingCheckListId": drivingCheckListId,
    "passBookExists": passBookExists,
    "passBookPath": passBookPath,
    "passBookCheckListId": passBookCheckListId,
    "passportExists": passportExists,
    "passportCheckListId": passportCheckListId,
    "passportPath": passportPath,
    "grDocs": List<dynamic>.from(grDocs.map((x) => x.toJson())),
    "errormsg": errormsg,
    "isvalide": isvalide,
  };
}

class GrDoc {
  bool addharExists;
  dynamic aadharPath;
  dynamic aadharBPath;
  bool voterExists;
  String voterPath;
  dynamic voterBPath;
  bool panExists;
  dynamic panPath;
  bool drivingExists;
  dynamic drivingPath;
  String grSno;

  GrDoc({
    required this.addharExists,
    required this.aadharPath,
    required this.aadharBPath,
    required this.voterExists,
    required this.voterPath,
    required this.voterBPath,
    required this.panExists,
    required this.panPath,
    required this.drivingExists,
    required this.drivingPath,
    required this.grSno,
  });

  factory GrDoc.fromJson(Map<String, dynamic> json) => GrDoc(
    addharExists: json["addharExists"]??"",
    aadharPath: json["aadharPath"]??"",
    aadharBPath: json["aadharBPath"]??"",
    voterExists: json["voterExists"]??"",
    voterPath: json["voterPath"]??"",
    voterBPath: json["voterBPath"]??"",
    panExists: json["panExists"]??"",
    panPath: json["panPath"]??"",
    drivingExists: json["drivingExists"]??"",
    drivingPath: json["drivingPath"]??"",
    grSno: json["gr_Sno"],
  );

  Map<String, dynamic> toJson() => {
    "addharExists": addharExists,
    "aadharPath": aadharPath,
    "aadharBPath": aadharBPath,
    "voterExists": voterExists,
    "voterPath": voterPath,
    "voterBPath": voterBPath,
    "panExists": panExists,
    "panPath": panPath,
    "drivingExists": drivingExists,
    "drivingPath": drivingPath,
    "gr_Sno": grSno,
  };
}
