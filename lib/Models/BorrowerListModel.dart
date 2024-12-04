// To parse this JSON data, do
//
//     final borrowerListModel = borrowerListModelFromJson(jsonString);

import 'dart:convert';

BorrowerListModel borrowerListModelFromJson(String str) => BorrowerListModel.fromJson(json.decode(str));

String borrowerListModelToJson(BorrowerListModel data) => json.encode(data.toJson());

class BorrowerListModel {
  int statuscode;
  String message;
  List<BorrowerListDataModel> data;

  BorrowerListModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory BorrowerListModel.fromJson(Map<String, dynamic> json) => BorrowerListModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<BorrowerListDataModel>.from(json["data"].map((x) => BorrowerListDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BorrowerListDataModel {
  int id;
  int fiCode;
  String creator;
  String dob;
  String gender;
  String aadharNo;
  String title;
  String fullName;
  String cast;
  String pAddress;
  String pPhone;
  String currentAddress;
  String groupCode;
  String branchCode;
  String borrSignStatus;
  String errormsg;
  bool isvalid;
  String eSignDoc;
  String profilePic;

  BorrowerListDataModel({
    required this.id,
    required this.fiCode,
    required this.creator,
    required this.dob,
    required this.gender,
    required this.aadharNo,
    required this.title,
    required this.fullName,
    required this.cast,
    required this.pAddress,
    required this.pPhone,
    required this.currentAddress,
    required this.groupCode,
    required this.branchCode,
    required this.borrSignStatus,
    required this.errormsg,
    required this.isvalid,
    required this.eSignDoc,
    required this.profilePic,
  });

  factory BorrowerListDataModel.fromJson(Map<String, dynamic> json) => BorrowerListDataModel(
    id: json["id"]??"",
    fiCode: json["fiCode"]??"",
    creator: json["creator"]??"",
    dob: json["dob"]??"",
    gender: json["gender"]??"",
    aadharNo: json["aadhar_no"]??"",
    title: json["title"]??"",
    fullName: json["fullName"]??"",
    cast: json["cast"]??"",
    pAddress: json["p_Address"]??"",
    pPhone: json["p_Phone"]??"",
    currentAddress: json["current_Address"]??"",
    groupCode: json["group_code"]??"",
    branchCode: json["branch_code"]??"",
    borrSignStatus: json["borrSignStatus"]??"",
    errormsg: json["errormsg"]??"",
    isvalid: json["isvalid"]??"",
    eSignDoc: json["eSignDoc"]??"",
    profilePic: json["profilePic"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fiCode": fiCode,
    "creator": creator,
    "dob": dob,
    "gender": gender,
    "aadhar_no": aadharNo,
    "title": title,
    "fullName": fullName,
    "cast": cast,
    "p_Address": pAddress,
    "p_Phone": pPhone,
    "current_Address": currentAddress,
    "group_code": groupCode,
    "branch_code": branchCode,
    "borrSignStatus": borrSignStatus,
    "errormsg": errormsg,
    "isvalid": isvalid,
    "eSignDoc": eSignDoc,
    "profilePic": profilePic,
  };
}
