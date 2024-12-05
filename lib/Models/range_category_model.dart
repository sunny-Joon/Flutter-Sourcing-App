import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Model Classes
RangeCategoryModel rangeCategoryModelFromJson(String str) => RangeCategoryModel.fromJson(json.decode(str));

String rangeCategoryModelToJson(RangeCategoryModel data) => json.encode(data.toJson());

class RangeCategoryModel {
  int statuscode;
  String message;
  List<RangeCategoryDataModel> data;

  RangeCategoryModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory RangeCategoryModel.fromJson(Map<String, dynamic> json) => RangeCategoryModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<RangeCategoryDataModel>.from(json["data"].map((x) => RangeCategoryDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RangeCategoryDataModel {
  String catKey;
  String groupDescriptionEn;
  String groupDescriptionHi;
  String descriptionEn;
  String descriptionHi;
  int sortOrder;
  String code;

  RangeCategoryDataModel({
    required this.catKey,
    required this.groupDescriptionEn,
    required this.groupDescriptionHi,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.sortOrder,
    required this.code,
  });

  factory RangeCategoryDataModel.fromJson(Map<String, dynamic> json) => RangeCategoryDataModel(
    catKey: json["cat_key"],
    groupDescriptionEn: json["groupDescriptionEn"],
    groupDescriptionHi: json["groupDescriptionHi"],
    descriptionEn: json["descriptionEn"],
    descriptionHi: json["descriptionHi"],
    sortOrder: json["sortOrder"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "cat_key": catKey,
    "groupDescriptionEn": groupDescriptionEn,
    "groupDescriptionHi": groupDescriptionHi,
    "descriptionEn": descriptionEn,
    "descriptionHi": descriptionHi,
    "sortOrder": sortOrder,
    "code": code,
  };
}

