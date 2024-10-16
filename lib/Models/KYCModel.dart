import 'dart:convert';

KycModel kycModelFromJson(String str) => KycModel.fromJson(json.decode(str));

String kycModelToJson(KycModel data) => json.encode(data.toJson());

class KycModel {
  int statuscode;
  String message;
  List<KycDataModel> data;

  KycModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory KycModel.fromJson(Map<String, dynamic> json) => KycModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<KycDataModel>.from(json["data"].map((x) => KycDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class KycDataModel {
  int fiId;
  String errormsg;
  bool isvalide;

  KycDataModel({
    required this.fiId,
    required this.errormsg,
    required this.isvalide,
  });

  factory KycDataModel.fromJson(Map<String, dynamic> json) => KycDataModel(
    fiId: json["fi_Id"],
    errormsg: json["errormsg"],
    isvalide: json["isvalide"],
  );

  Map<String, dynamic> toJson() => {
    "fi_Id": fiId,
    "errormsg": errormsg,
    "isvalide": isvalide,
  };
}
