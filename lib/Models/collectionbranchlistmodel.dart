// To parse this JSON data, do
//
//     final collectionBranchListModel = collectionBranchListModelFromJson(jsonString);

import 'dart:convert';

CollectionBranchListModel collectionBranchListModelFromJson(String str) => CollectionBranchListModel.fromJson(json.decode(str));

String collectionBranchListModelToJson(CollectionBranchListModel data) => json.encode(data.toJson());

class CollectionBranchListModel {
  int statuscode;
  String message;
  List<CollectionBranchListDataModel> data;

  CollectionBranchListModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CollectionBranchListModel.fromJson(Map<String, dynamic> json) => CollectionBranchListModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<CollectionBranchListDataModel>.from(json["data"].map((x) => CollectionBranchListDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CollectionBranchListDataModel {
  int imeino;
  String focode;
  String foName;
  String creator;
  String isactive;
  String database;
  String tag;
  String areaCd;
  String areaName;
  String description;
  String fiExecCode;
  String fiExecName;
  String errormsg;
  bool isvalid;

  CollectionBranchListDataModel({
    required this.imeino,
    required this.focode,
    required this.foName,
    required this.creator,
    required this.isactive,
    required this.database,
    required this.tag,
    required this.areaCd,
    required this.areaName,
    required this.description,
    required this.fiExecCode,
    required this.fiExecName,
    required this.errormsg,
    required this.isvalid,
  });

  factory CollectionBranchListDataModel.fromJson(Map<String, dynamic> json) => CollectionBranchListDataModel(
    imeino: json["imeino"]??"",
    focode: json["focode"]??"",
    foName: json["foName"]??"",
    creator: json["creator"]??"",
    isactive: json["isactive"]??"",
    database: json["database"]??"",
    tag: json["tag"]??"",
    areaCd: json["areaCd"]??"",
    areaName: json["areaName"]??"",
    description: json["description"]??"",
    fiExecCode: json["fiExecCode"]??"",
    fiExecName: json["fiExecName"]??"",
    errormsg: json["errormsg"]??"",
    isvalid: json["isvalid"]??"",
  );

  Map<String, dynamic> toJson() => {
    "imeino": imeino,
    "focode": focode,
    "foName": foName,
    "creator": creator,
    "isactive": isactive,
    "database": database,
    "tag": tag,
    "areaCd": areaCd,
    "areaName": areaName,
    "description": description,
    "fiExecCode": fiExecCode,
    "fiExecName": fiExecName,
    "errormsg": errormsg,
    "isvalid": isvalid,
  };
}
