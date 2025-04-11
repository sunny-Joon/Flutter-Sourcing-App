import 'dart:convert';

GroupModel groupModelFromJson(String str) => GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

class GroupModel {
  int statuscode;
  String message;
  List<GroupDataModel> data;

  GroupModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<GroupDataModel>.from(json["data"].map((x) => GroupDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GroupDataModel {
  String groupCode;
  String groupCodeName;
  String centerName;

  GroupDataModel({
    required this.groupCode,
    required this.groupCodeName,
    required this.centerName
  });

  factory GroupDataModel.fromJson(Map<String, dynamic> json) => GroupDataModel(
      groupCode: json["groupCode"],
      groupCodeName: json["groupCodeName"],
      centerName: json["centerName"]
  );

  Map<String, dynamic> toJson() => {
    "groupCode": groupCode,
    "groupCodeName": groupCodeName,
    "centerName": centerName
  };
}