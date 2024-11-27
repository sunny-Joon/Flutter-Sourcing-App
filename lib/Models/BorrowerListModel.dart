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
  String creator;
  int fiCode;
  DateTime dob;
  String gender;
  String title;
  String fullName;
  dynamic cast;
  String pAddress;
  String pPhone;
  String currentAddress;
  String groupCode;
  String branchCode;
  String borrSignStatus;
  String errormsg;
  bool isvalide;
  String downloadLink;
  String aadhar_no;

  BorrowerListDataModel({
    required this.id,
    required this.creator,
    required this.fiCode,
    required this.dob,
    required this.gender,
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
    required this.isvalide,
    required this.downloadLink,
    required this.aadhar_no,
  });

  factory BorrowerListDataModel.fromJson(Map<String, dynamic> json) => BorrowerListDataModel(
    id: json["id"],
    creator: json["creator"],
    fiCode: json["fiCode"],
    dob: DateTime.parse(json["dob"]),
    gender: json["gender"],
    title: json["title"],
    fullName: json["fullName"],
    cast: json["cast"],
    pAddress: json["p_Address"],
    pPhone: json["p_Phone"],
    currentAddress: json["current_Address"],
    groupCode: json["group_code"]??"",
    branchCode: json["branch_code"]??"",
    borrSignStatus: json["borrSignStatus"],
    errormsg: json["errormsg"],
    isvalide: json["isvalid"],
    downloadLink: json["downloadLink"]??"",
    aadhar_no: json["aadhar_no"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "creator": creator,
    "fiCode": fiCode,
    "dob": dob.toIso8601String(),
    "gender": gender,
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
    "isvalide": isvalide,
    "downloadLink": downloadLink,
    "aadhar_no": aadhar_no,
  };
}
