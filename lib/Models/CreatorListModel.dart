// To parse this JSON data, do
//
//     final creatorListModel = creatorListModelFromJson(jsonString);

import 'dart:convert';

CreatorListModel creatorListModelFromJson(String str) => CreatorListModel.fromJson(json.decode(str));

String creatorListModelToJson(CreatorListModel data) => json.encode(data.toJson());

class CreatorListModel {
  int statuscode;
  String message;
  List<CreatorListDataModel> data;

  CreatorListModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CreatorListModel.fromJson(Map<String, dynamic> json) => CreatorListModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<CreatorListDataModel>.from(json["data"].map((x) => CreatorListDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CreatorListDataModel {
  int creatorId;
  String creator;

  CreatorListDataModel({
    required this.creatorId,
    required this.creator,
  });

  factory CreatorListDataModel.fromJson(Map<String, dynamic> json) => CreatorListDataModel(
    creatorId: json["creatorID"],
    creator: json["creator"],
  );

  Map<String, dynamic> toJson() => {
    "creatorID": creatorId,
    "creator": creator,
  };
}
