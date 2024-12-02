// To parse this JSON data, do
//
//     final ocrResponse = ocrResponseFromJson(jsonString);

import 'dart:convert';

OcrResponse ocrResponseFromJson(String str) => OcrResponse.fromJson(json.decode(str));

String ocrResponseToJson(OcrResponse data) => json.encode(data.toJson());

class OcrResponse {
  int statusCode;
  String message;
  Data data;

  OcrResponse({
   required this.statusCode,
   required this.message,
   required this.data,
  });

  factory OcrResponse.fromJson(Map<String, dynamic> json) => OcrResponse(
    statusCode: json["statusCode"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String name;
  String dob;
  String panNo;
  String gender;
  String adharId;
  String address1;
  String stateName;
  String cityName;
  String pincode;
  String voterfatherName;
  String voterHusbandName;
  String guardianName;
  String relation;
  String voterId;
  bool status;
  String errorReason;
  String errorCode;
  String errorMessage;
  int statusCode;
  String reasonPhase;
  bool isSuccessStatusCode;
  String responseContent;

  Data({
    required this.name,
    required this.dob,
    required this.panNo,
    required this.gender,
    required this.adharId,
    required this.address1,
    required this.stateName,
    required this.cityName,
    required this.pincode,
    required this.voterfatherName,
    required this.voterHusbandName,
    required this.guardianName,
    required this.relation,
    required this.voterId,
    required this.status,
    required this.errorReason,
    required this.errorCode,
    required this.errorMessage,
    required this.statusCode,
    required this.reasonPhase,
    required this.isSuccessStatusCode,
    required this.responseContent,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"]??"",
    dob: json["dob"]??"",
    panNo: json["pan_No"]??"",
    gender: json["gender"]??"",
    adharId: json["adharId"]??"",
    address1: json["address1"]??"",
    stateName: json["stateName"]??"",
    cityName: json["cityName"]??"",
    pincode: json["pincode"]??"",
    voterfatherName: json["voterfatherName"]??"",
    voterHusbandName: json["voterHusbandName"]??"",
    guardianName: json["guardianName"]??"",
    relation: json["relation"]??"",
    voterId: json["voterId"]??"",
    status: json["status"]??"",
    errorReason: json["error_reason"]??"",
    errorCode: json["error_code"]??"",
    errorMessage: json["error_message"]??"",
    statusCode: json["statusCode"]??0,
    reasonPhase: json["reasonPhase"]??"",
    isSuccessStatusCode: json["isSuccessStatusCode"]??"",
    responseContent: json["responseContent"]??"",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "dob": dob,
    "pan_No": panNo,
    "gender": gender,
    "adharId": adharId,
    "address1": address1,
    "stateName": stateName,
    "cityName": cityName,
    "pincode": pincode,
    "voterfatherName": voterfatherName,
    "voterHusbandName": voterHusbandName,
    "guardianName": guardianName,
    "relation": relation,
    "voterId": voterId,
    "status": status,
    "error_reason": errorReason,
    "error_code": errorCode,
    "error_message": errorMessage,
    "statusCode": statusCode,
    "reasonPhase": reasonPhase,
    "isSuccessStatusCode": isSuccessStatusCode,
    "responseContent": responseContent,
  };
}
