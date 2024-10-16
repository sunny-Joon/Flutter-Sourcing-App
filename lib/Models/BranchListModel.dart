import 'dart:convert';

ManagerListModel managerListModelFromJson(String str) => ManagerListModel.fromJson(json.decode(str));

String managerListModelToJson(ManagerListModel data) => json.encode(data.toJson());

class ManagerListModel {
  int statuscode;
  String message;
  List<BranchListDataModel> data;

  ManagerListModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory ManagerListModel.fromJson(Map<String, dynamic> json) => ManagerListModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<BranchListDataModel>.from(json["data"].map((x) => BranchListDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BranchListDataModel {
  String branchCode;
  String branchName;

  BranchListDataModel({
    required this.branchCode,
    required this.branchName,
  });

  factory BranchListDataModel.fromJson(Map<String, dynamic> json) => BranchListDataModel(
    branchCode: json["branchCode"],
    branchName: json["branchName"],
  );

  Map<String, dynamic> toJson() => {
    "branchCode": branchCode,
    "branchName": branchName,
  };
}
