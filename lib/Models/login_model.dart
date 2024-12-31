// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  int statuscode;
  String message;
  LoginDataModel data;

  LoginModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: LoginDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data.toJson(),
  };
}

class LoginDataModel {
  List<FoImei> foImei;
  List<GetCreatorList> getCreatorList;
  TokenDetails tokenDetails;

  LoginDataModel({
    required this.foImei,
    required this.getCreatorList,
    required this.tokenDetails,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
    foImei: List<FoImei>.from(json["foImei"].map((x) => FoImei.fromJson(x))),
    getCreatorList: List<GetCreatorList>.from(json["getCreatorList"].map((x) => GetCreatorList.fromJson(x))),
    tokenDetails: TokenDetails.fromJson(json["tokenDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "foImei": List<dynamic>.from(foImei.map((x) => x.toJson())),
    "getCreatorList": List<dynamic>.from(getCreatorList.map((x) => x.toJson())),
    "tokenDetails": tokenDetails.toJson(),
  };
}

class FoImei {
  int imeino;
  String actualYn;
  bool isActive;
  int newAppVerison;
  String appDownPath;
  String requestUrl;
  String simno;
  String creator;
  String creatorUserId;
  int targetCommAmt;
  String name;
  String roleName;
  String designation;
  String departmentName;
  String mobNo;
  String tag;

  FoImei({
    required this.imeino,
    required this.actualYn,
    required this.isActive,
    required this.newAppVerison,
    required this.appDownPath,
    required this.requestUrl,
    required this.simno,
    required this.creator,
    required this.creatorUserId,
    required this.targetCommAmt,
    required this.name,
    required this.roleName,
    required this.designation,
    required this.departmentName,
    required this.mobNo,
    required this.tag,
  });

  factory FoImei.fromJson(Map<String, dynamic> json) => FoImei(
    imeino: json["imeino"]??"",
    actualYn: json["actualYN"]??"",
    isActive: json["isActive"]??"",
    newAppVerison: json["newAppVerison"]??"",
    appDownPath: json["appDownPath"]??"",
    requestUrl: json["requestUrl"]??"",
    simno: json["simno"]??"",
    creator: json["creator"]??"",
    creatorUserId: json["creator_UserID"]??"",
    targetCommAmt: json["targetCommAmt"]??"",
    name: json["name"]??"",
    roleName: json["roleName"]??"",
    designation: json["designation"]??"",
    departmentName: json["departmentName"]??"",
    mobNo: json["mobNO"]??"",
    tag: json["tag"]??"",
  );

  Map<String, dynamic> toJson() => {
    "imeino": imeino,
    "actualYN": actualYn,
    "isActive": isActive,
    "newAppVerison": newAppVerison,
    "appDownPath": appDownPath,
    "requestUrl": requestUrl,
    "simno": simno,
    "creator": creator,
    "creator_UserID": creatorUserId,
    "targetCommAmt": targetCommAmt,
    "name": name,
    "roleName": roleName,
    "designation": designation,
    "departmentName": departmentName,
    "mobNO": mobNo,
    "tag": tag,
  };
}

class GetCreatorList {
  int creatorId;
  String creatorName;

  GetCreatorList({
    required this.creatorId,
    required this.creatorName,
  });

  factory GetCreatorList.fromJson(Map<String, dynamic> json) => GetCreatorList(
    creatorId: json["creatorID"]??"",
    creatorName: json["creatorName"]??"",
  );

  Map<String, dynamic> toJson() => {
    "creatorID": creatorId,
    "creatorName": creatorName,
  };
}

class TokenDetails {
  int id;
  String token;
  String userName;
  String imeino;
  String deviceSrNo;
  String password;
  String validity;
  String refreshToken;
  String role;
  int guId;
  String expiredTime;

  TokenDetails({
    required this.id,
    required this.token,
    required this.userName,
    required this.imeino,
    required this.deviceSrNo,
    required this.password,
    required this.validity,
    required this.refreshToken,
    required this.role,
    required this.guId,
    required this.expiredTime,
  });

  factory TokenDetails.fromJson(Map<String, dynamic> json) => TokenDetails(
    id: json["id"]??"",
    token: json["token"]??"",
    userName: json["userName"]??"",
    imeino: json["imeino"]??"",
    deviceSrNo: json["deviceSrNo"]??"",
    password: json["password"]??"",
    validity: json["validity"]??"",
    refreshToken: json["refreshToken"]??"",
    role: json["role"]??"",
    guId: json["guId"]??"",
    expiredTime: json["expiredTime"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
    "userName": userName,
    "imeino": imeino,
    "deviceSrNo": deviceSrNo,
    "password": password,
    "validity": validity,
    "refreshToken": refreshToken,
    "role": role,
    "guId": guId,
    "expiredTime": expiredTime,
  };
}
