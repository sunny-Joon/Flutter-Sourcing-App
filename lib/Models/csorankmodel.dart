// To parse this JSON data, do
//
//     final csoRankModel = csoRankModelFromJson(jsonString);

import 'dart:convert';

CsoRankModel csoRankModelFromJson(String str) => CsoRankModel.fromJson(json.decode(str));

String csoRankModelToJson(CsoRankModel data) => json.encode(data.toJson());

class CsoRankModel {
  int statuscode;
  String message;
  List<CsoRankDataModel> data;

  CsoRankModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CsoRankModel.fromJson(Map<String, dynamic> json) => CsoRankModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<CsoRankDataModel>.from(json["data"].map((x) => CsoRankDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CsoRankDataModel {
  String name;
  int targetAmmount;
  int rank;
  String errormsg;
  bool isvalid;

  CsoRankDataModel({
    required this.name,
    required this.targetAmmount,
    required this.rank,
    required this.errormsg,
    required this.isvalid,
  });

  factory CsoRankDataModel.fromJson(Map<String, dynamic> json) => CsoRankDataModel(
    name: json["name"]??"",
    targetAmmount: json["targetAmmount"]??0,
    rank: json["rank"]??0,
    errormsg: json["errormsg"]??"",
    isvalid: json["isvalid"]??false,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "targetAmmount": targetAmmount,
    "rank": rank,
    "errormsg": errormsg,
    "isvalid": isvalid,
  };
}
