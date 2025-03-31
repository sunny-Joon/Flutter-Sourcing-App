// To parse this JSON data, do
//
//     final collectionBorrowerListModel = collectionBorrowerListModelFromJson(jsonString);

import 'dart:convert';

// To parse this JSON data, do
//
//     final collectionBorrowerListModel = collectionBorrowerListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CollectionBorrowerListModel collectionBorrowerListModelFromJson(String str) => CollectionBorrowerListModel.fromJson(json.decode(str));

String collectionBorrowerListModelToJson(CollectionBorrowerListModel data) => json.encode(data.toJson());

class CollectionBorrowerListModel {
  int statuscode;
  String message;
  List<CollectionBorrowerListDataModel> data;

  CollectionBorrowerListModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CollectionBorrowerListModel.fromJson(Map<String, dynamic> json) => CollectionBorrowerListModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<CollectionBorrowerListDataModel>.from(json["data"].map((x) => CollectionBorrowerListDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CollectionBorrowerListDataModel {
  String db;
  int fi_Id;
  String dbName;
  String creator;
  String foCode;
  String? partyCd;
  String custName;
  String mobile;
  String fhName;
  String groupCode;
  String address;
  String? aadhar;
  String caseCode;
  String firstInstDate;
  int noOfInsts;
  double totalDueAmt;
  int totalDueCnt;
  double totalRecdAmt;
  int totalRecdCnt;
  double instsAmtDue;
  int nofInstDue;
  List<InstDatum> instData;
  double toBeDueAmt;
  String? toBeDueDate;
  double futureDue;
  String instDueAsOn;
  String isNachReg;
  String dataAsOn;
  double interestAmt;
  String schmCode;
  String profilePic;
  String errormsg;
  bool isvalid;

  CollectionBorrowerListDataModel({
    required this.db,
    required this.fi_Id,
    required this.dbName,
    required this.creator,
    required this.foCode,
    required this.partyCd,
    required this.custName,
    required this.mobile,
    required this.fhName,
    required this.groupCode,
    required this.address,
    required this.aadhar,
    required this.caseCode,
    required this.firstInstDate,
    required this.noOfInsts,
    required this.totalDueAmt,
    required this.totalDueCnt,
    required this.totalRecdAmt,
    required this.totalRecdCnt,
    required this.instsAmtDue,
    required this.nofInstDue,
    required this.instData,
    required this.toBeDueAmt,
    required this.toBeDueDate,
    required this.futureDue,
    required this.instDueAsOn,
    required this.isNachReg,
    required this.dataAsOn,
    required this.interestAmt,
    required this.schmCode,
    required this.profilePic,
    required this.errormsg,
    required this.isvalid,
  });

  factory CollectionBorrowerListDataModel.fromJson(Map<String, dynamic> json) => CollectionBorrowerListDataModel(
    db: json["db"]??"",
    fi_Id: json["fi_Id"]??"",
    dbName: json["dbName"]??"",
    creator: json["creator"]??"",
    foCode: json["foCode"]??"",
    partyCd: json["partyCd"]??"",
    custName: json["custName"]??"",
    mobile: json["mobile"]??"",
    fhName: json["fhName"]??"",
    groupCode: json["groupCode"]??"",
    address: json["address"]??"",
    aadhar: json["aadhar"]??"",
    caseCode: json["caseCode"]??"",
    firstInstDate: json["firstInstDate"]??"",
    noOfInsts: json["noOfInsts"],
    totalDueAmt: json["totalDueAmt"],
    totalDueCnt: json["totalDueCnt"],
    totalRecdAmt: json["totalRecdAmt"],
    totalRecdCnt: json["totalRecdCnt"],
    instsAmtDue: json["instsAmtDue"],
    nofInstDue: json["nofInstDue"],
    instData: List<InstDatum>.from(json["instData"].map((x) => InstDatum.fromJson(x))),
    toBeDueAmt: json["toBeDueAmt"],
    toBeDueDate: json["toBeDueDate"]??"",
    futureDue: json["futureDue"],
    instDueAsOn: json["instDueAsOn"]??"",
    isNachReg: json["isNachReg"]??"",
    dataAsOn: json["dataAsOn"]??"",
    interestAmt: json["interestAmt"],
    schmCode: json["schmCode"]??"",
    profilePic: json["profilePic"]??"",
    errormsg: json["errormsg"]??"",
    isvalid: json["isvalid"],
  );

  Map<String, dynamic> toJson() => {
    "db": db,
    "fi_Id": fi_Id,
    "dbName": dbName,
    "creator": creator,
    "foCode": foCode,
    "partyCd": partyCd,
    "custName": custName,
    "mobile": mobile,
    "fhName": fhName,
    "groupCode": groupCode,
    "address": address,
    "aadhar": aadhar,
    "caseCode": caseCode,
    "firstInstDate": firstInstDate,
    "noOfInsts": noOfInsts,
    "totalDueAmt": totalDueAmt,
    "totalDueCnt": totalDueCnt,
    "totalRecdAmt": totalRecdAmt,
    "totalRecdCnt": totalRecdCnt,
    "instsAmtDue": instsAmtDue,
    "nofInstDue": nofInstDue,
    "instData": List<dynamic>.from(instData.map((x) => x.toJson())),
    "toBeDueAmt": toBeDueAmt,
    "toBeDueDate": toBeDueDate,
    "futureDue": futureDue,
    "instDueAsOn": instDueAsOn,
    "isNachReg": isNachReg,
    "dataAsOn": dataAsOn,
    "interestAmt": interestAmt,
    "schmCode": schmCode,
    "profilePic": profilePic,
    "errormsg": errormsg,
    "isvalid": isvalid,
  };
}

class InstDatum {
  String dueDate;
  String amount;

  InstDatum({
    required this.dueDate,
    required this.amount,
  });

  factory InstDatum.fromJson(Map<String, dynamic> json) => InstDatum(
    dueDate: json["dueDate"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "dueDate": dueDate,
    "amount": amount,
  };
}
