
import 'dart:convert';

BannerPostModel bannerPostModelFromJson(String str) => BannerPostModel.fromJson(json.decode(str));

String bannerPostModelToJson(BannerPostModel data) => json.encode(data.toJson());

class BannerPostModel {
  int statuscode;
  String message;
  List<BannerPostModelData> data;

  BannerPostModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory BannerPostModel.fromJson(Map<String, dynamic> json) => BannerPostModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<BannerPostModelData>.from(json["data"].map((x) => BannerPostModelData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BannerPostModelData {
  String advertisement;
  String description;
  String appType;
  String messageType;
  String banner;

  BannerPostModelData({
    required this.advertisement,
    required this.description,
    required this.appType,
    required this.messageType,
    required this.banner,
  });

  factory BannerPostModelData.fromJson(Map<String, dynamic> json) => BannerPostModelData(
    advertisement: json["advertisement"]??"",
    description: json["description"]??"",
    appType: json["appType"]??"",
    messageType: json["messageType"]??"",
    banner: json["banner"]??"",
  );

  Map<String, dynamic> toJson() => {
    "advertisement": advertisement,
    "description": description,
    "appType": appType,
    "messageType": messageType,
    "banner": banner,
  };
}
