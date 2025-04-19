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
  double latitude;
  double longitude;

  GroupDataModel({
    required this.groupCode,
    required this.groupCodeName,
    required this.centerName,
    required this.latitude,
    required this.longitude
  });

  factory GroupDataModel.fromJson(Map<String, dynamic> json) => GroupDataModel(
      groupCode: json["groupCode"],
      groupCodeName: json["groupCodeName"],
      centerName: json["centerName"],
      latitude: json["latitude"],
  longitude: json["longitude"]
  );

  Map<String, dynamic> toJson() => {
    "groupCode": groupCode,
    "groupCodeName": groupCodeName,
    "centerName": centerName,
    "latitude": latitude,
    "longitude": longitude
  };
}