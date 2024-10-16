// To parse this JSON data, do
//
//     final branchModel = branchModelFromJson(jsonString);

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
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<BranchDataModel>.from(json["data"].map((x) => BranchDataModel.fromJson(x))),
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

  BranchDataModel({
    required this.branchCode,
    required this.branchName,
  });

  factory BranchDataModel.fromJson(Map<String, dynamic> json) => BranchDataModel(
    branchCode: json["branchCode"],
    branchName: json["branchName"],
  );

  Map<String, dynamic> toJson() => {
    "branchCode": branchCode,
    "branchName": branchName,
  };
}
