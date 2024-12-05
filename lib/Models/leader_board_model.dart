// To parse this JSON data, do
//
//     final leaderboardModel = leaderboardModelFromJson(jsonString);

import 'dart:convert';

LeaderboardModel leaderboardModelFromJson(String str) => LeaderboardModel.fromJson(json.decode(str));

String leaderboardModelToJson(LeaderboardModel data) => json.encode(data.toJson());

class LeaderboardModel {
  int statuscode;
  String message;
  List<LeaderboardDataModel> data;

  LeaderboardModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) => LeaderboardModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<LeaderboardDataModel>.from(json["data"].map((x) => LeaderboardDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class LeaderboardDataModel {
  String userId;
  String creator;
  String name;
  String totalDisbursementAmt;
  String disbursementMonth;

  LeaderboardDataModel({
    required this.userId,
    required this.creator,
    required this.name,
    required this.totalDisbursementAmt,
    required this.disbursementMonth,
  });

  factory LeaderboardDataModel.fromJson(Map<String, dynamic> json) => LeaderboardDataModel(
    userId: json["userId"],
    creator: json["creator"],
    name: json["name"],
    totalDisbursementAmt: json["totalDisbursementAmt"],
    disbursementMonth: json["disbursementMonth"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "creator": creator,
    "name": name,
    "totalDisbursementAmt": totalDisbursementAmt,
    "disbursementMonth": disbursementMonth,
  };
}
