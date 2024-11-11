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
    message: json["message"] ?? '', // Provide default empty string if null
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
  String? docname;
  bool addharExists;
  String? aadharPath;
  String? aadharBPath;
  bool voterExists;
  String? voterPath;
  String? voterBPath;
  bool panExists;
  String? panPath;
  bool drivingExists;
  String? drivingPath;
  bool passBookExists;
  String? passBookPath;
  String? passBookBPath;
  List<GrDoc> grDocs;
  String? errormsg;
  String? isvalide;

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
    fiId: json["fi_Id"] ?? 0,
    docname: json["docname"] ?? null,
    addharExists: json["addharExists"] ?? false,
    aadharPath: json["aadharPath"] ?? null,
    aadharBPath: json["aadharBPath"] ?? null,
    voterExists: json["voterExists"] ?? false,
    voterPath: json["voterPath"] ?? null,
    voterBPath: json["voterBPath"] ?? null,
    panExists: json["panExists"] ?? false,
    panPath: json["panPath"] ?? null,
    drivingExists: json["drivingExists"] ?? false,
    drivingPath: json["drivingPath"] ?? null,
    passBookExists: json["passBookExists"] ?? false,
    passBookPath: json["passBookPath"] ?? null,
    passBookBPath: json["passBookBPath"] ?? null,
    grDocs: List<GrDoc>.from(json["grDocs"]?.map((x) => GrDoc.fromJson(x)) ?? []),
    errormsg: json["errormsg"] ?? null,
    isvalide: json["isvalide"] ?? null,
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
  String? aadharPath;
  String? aadharBPath;
  bool voterExists;
  String? voterPath;
  String? voterBPath;
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
    addharExists: json["addharExists"] ?? false,
    aadharPath: json["aadharPath"] ?? null,
    aadharBPath: json["aadharBPath"] ?? null,
    voterExists: json["voterExists"] ?? false,
    voterPath: json["voterPath"] ?? null,
    voterBPath: json["voterBPath"] ?? null,
    panExists: json["panExists"] ?? false,
    panPath: json["panPath"] ?? '',
    drivingExists: json["drivingExists"] ?? false,
    drivingPath: json["drivingPath"] ?? '',
    grSno: json["gr_Sno"] ?? '',
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
