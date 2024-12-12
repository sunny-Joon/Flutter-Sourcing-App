// To parse this JSON data, do
//
//     final attendanceStatusModel = attendanceStatusModelFromJson(jsonString);

import 'dart:convert';

AttendanceStatusModel attendanceStatusModelFromJson(String str) => AttendanceStatusModel.fromJson(json.decode(str));

String attendanceStatusModelToJson(AttendanceStatusModel data) => json.encode(data.toJson());

class AttendanceStatusModel {
  int statuscode;
  String message;
  List<Datum> data;

  AttendanceStatusModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory AttendanceStatusModel.fromJson(Map<String, dynamic> json) => AttendanceStatusModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String userName;
  String inTime;
  String outTime;
  String inLocation;
  String outLocation;
  int status;
  int imeino;

  Datum({
    required this.id,
    required this.userName,
    required this.inTime,
    required this.outTime,
    required this.inLocation,
    required this.outLocation,
    required this.status,
    required this.imeino,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"]??"",
    userName: json["userName"]??"",
    inTime: json["inTime"]??"",
    outTime: json["outTime"]??"",
    inLocation: json["inLocation"]??"",
    outLocation: json["outLocation"]??"",
    status: json["status"]??"",
    imeino: json["imeino"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userName": userName,
    "inTime": inTime,
    "outTime": outTime,
    "inLocation": inLocation,
    "outLocation": outLocation,
    "status": status,
    "imeino": imeino,
  };
}
