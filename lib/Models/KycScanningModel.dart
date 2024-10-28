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
  dynamic aadharBPath;
  bool voterExists;
  dynamic voterPath;
  dynamic voterBPath;
  bool panExists;
  dynamic panPath;
  bool drivingExists;
  dynamic drivingPath;
  bool passBookExists;
  dynamic passBookPath;
  dynamic passBookBPath;
  List<GrDoc> grDocs;
  dynamic errormsg;
  dynamic isvalide;

  KycScanningDataModel({
    required this.fiId,
    this.docname,
    required this.addharExists,
    this.aadharPath,
    this.aadharBPath,
    required this.voterExists,
    this.voterPath,
    this.voterBPath,
    required this.panExists,
    this.panPath,
    required this.drivingExists,
    this.drivingPath,
    required this.passBookExists,
    this.passBookPath,
    this.passBookBPath,
    required this.grDocs,
    this.errormsg,
    this.isvalide,
  });

  factory KycScanningDataModel.fromJson(Map<String, dynamic> json) => KycScanningDataModel(
    fiId: json["fi_Id"],
    docname: json["docname"],
    addharExists: json["addharExists"],
    aadharPath: json["aadharPath"],
    aadharBPath: json["aadharBPath"],
    voterExists: json["voterExists"],
    voterPath: json["voterPath"],
    voterBPath: json["voterBPath"],
    panExists: json["panExists"],
    panPath: json["panPath"],
    drivingExists: json["drivingExists"],
    drivingPath: json["drivingPath"],
    passBookExists: json["passBookExists"],
    passBookPath: json["passBookPath"],
    passBookBPath: json["passBookBPath"],
    grDocs: List<GrDoc>.from(json["grDocs"].map((x) => GrDoc.fromJson(x))),
    errormsg: json["errormsg"],
    isvalide: json["isvalide"],
  );

  Map<String, dynamic> toJson() => {
    "fi_Id": fiId,
    "docname": docname,
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
    "passBookExists": passBookExists,
    "passBookPath": passBookPath,
    "passBookBPath": passBookBPath,
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
  dynamic voterPath;
  dynamic voterBPath;
  bool panExists;
  String panPath;
  bool drivingExists;
  String drivingPath;
  String grSno;

  GrDoc({
    required this.addharExists,
    this.aadharPath,
    this.aadharBPath,
    required this.voterExists,
    this.voterPath,
    this.voterBPath,
    required this.panExists,
    required this.panPath,
    required this.drivingExists,
    required this.drivingPath,
    required this.grSno,
  });

  factory GrDoc.fromJson(Map<String, dynamic> json) => GrDoc(
    addharExists: json["addharExists"],
    aadharPath: json["aadharPath"],
    aadharBPath: json["aadharBPath"],
    voterExists: json["voterExists"],
    voterPath: json["voterPath"],
    voterBPath: json["voterBPath"],
    panExists: json["panExists"],
    panPath: json["panPath"],
    drivingExists: json["drivingExists"],
    drivingPath: json["drivingPath"],
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
