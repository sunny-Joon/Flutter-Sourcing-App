import 'dart:convert';

BranchModel branchModelFromJson(String str) => BranchModel.fromJson(json.decode(str));

String branchModelToJson(BranchModel data) => json.encode(data.toJson());

class BranchModel {
  int statuscode;
  String message;
  List<BranchDataModel> data;

  BranchModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    statuscode: json["statuscode"] ?? 0, // Default to 0 if null
    message: json["message"] ?? "No message", // Default message
    data: (json["data"] as List?)?.map((x) => BranchDataModel.fromJson(x)).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BranchDataModel {
  String branchCode;
  String branchName;
  String caseType;
  String dpd;
  String ntc;
  int isSourcing;
  int isDisbursed;
  int isCollection;
  int status;
  int disbursement;
  int crifScore;
  int functions;

  BranchDataModel({
    required this.branchCode,
    required this.branchName,
    required this.caseType,
    required this.dpd,
    required this.ntc,
    required this.isSourcing,
    required this.isDisbursed,
    required this.isCollection,
    required this.status,
    required this.disbursement,
    required this.crifScore,
    required this.functions,
  });

  factory BranchDataModel.fromJson(Map<String, dynamic> json) => BranchDataModel(
    branchCode: json["branchCode"] ?? "", // Default empty string if null
    branchName: json["branchName"] ?? "",
    caseType: json["caseType"] ?? "",
    dpd: json["dpd"] ?? "",
    ntc: json["ntc"] ?? "",
    isSourcing: json["isSourcing"] ?? 0, // Default to 0 if null
    isDisbursed: json["isDisbursed"] ?? 0,
    isCollection: json["isCollection"] ?? 0,
    status: json["status"] ?? 0,
    disbursement: json["disbursement"] ?? 0,
    crifScore: json["crifScore"] ?? 0,
    functions: json["functions"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "branchCode": branchCode,
    "branchName": branchName,
    "caseType": caseType,
    "dpd": dpd,
    "ntc": ntc,
    "isSourcing": isSourcing,
    "isDisbursed": isDisbursed,
    "isCollection": isCollection,
    "status": status,
    "disbursement": disbursement,
    "crifScore": crifScore,
    "functions": functions,
  };
}
