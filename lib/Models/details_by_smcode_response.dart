// To parse this JSON data, do
//
//     final detailsBySMcodeResponse = detailsBySMcodeResponseFromJson(jsonString);

import 'dart:convert';

DetailsBySMcodeResponse detailsBySMcodeResponseFromJson(String str) => DetailsBySMcodeResponse.fromJson(json.decode(str));

String detailsBySMcodeResponseToJson(DetailsBySMcodeResponse data) => json.encode(data.toJson());

class DetailsBySMcodeResponse {
  int statuscode;
  String message;
  List<DetailsBySMcodeData> data;

  DetailsBySMcodeResponse({
   required this.statuscode,
   required this.message,
   required this.data,
  });

  factory DetailsBySMcodeResponse.fromJson(Map<String, dynamic> json) => DetailsBySMcodeResponse(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<DetailsBySMcodeData>.from(json["data"].map((x) => DetailsBySMcodeData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DetailsBySMcodeData {
  String name;
  String mobileNo;

  DetailsBySMcodeData({
   required this.name,
   required this.mobileNo,
  });

  factory DetailsBySMcodeData.fromJson(Map<String, dynamic> json) => DetailsBySMcodeData(
    name: json["name"],
    mobileNo: json["mobileNo"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "mobileNo": mobileNo,
  };
}
