// To parse this JSON data, do
//
//     final getCollectionModel = getCollectionModelFromJson(jsonString);

import 'dart:convert';

GetCollectionModel getCollectionModelFromJson(String str) => GetCollectionModel.fromJson(json.decode(str));

String getCollectionModelToJson(GetCollectionModel data) => json.encode(data.toJson());

class GetCollectionModel {
  int statuscode;
  String message;
  List<Datum> data;

  GetCollectionModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory GetCollectionModel.fromJson(Map<String, dynamic> json) => GetCollectionModel(
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
  String db;
  String dbName;
  String creator;
  String foCode;
  String partyCd;
  String custName;
  String mobile;
  String fhName;
  String cityCode;
  String address;
  String aadhar;
  String caseCode;
  String firstInstDate;
  int noOfInsts;
  int totalDueAmt;
  int totalDueCnt;
  int totalRecdAmt;
  int totalRecdCnt;
  int instsAmtDue;
  int nofInstDue;
  String instData;
  int toBeDueAmt;
  String toBeDueDate;
  int futureDue;
  String instDueAsOn;
  String isNachReg;
  String dataAsOn;
  int interestAmt;
  String schmCode;
  String errormsg;
  bool isvalide;

  Datum({
    required this.db,
    required this.dbName,
    required this.creator,
    required this.foCode,
    required this.partyCd,
    required this.custName,
    required this.mobile,
    required this.fhName,
    required this.cityCode,
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
    required this.errormsg,
    required this.isvalide,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    db: json["db"]??"",
    dbName: json["dbName"]??"",
    creator: json["creator"]??"",
    foCode: json["foCode"]??"",
    partyCd: json["partyCd"]??"",
    custName: json["custName"]??"",
    mobile: json["mobile"]??"",
    fhName: json["fhName"]??"",
    cityCode: json["cityCode"]??"",
    address: json["address"]??"",
    aadhar: json["aadhar"]??"",
    caseCode: json["caseCode"]??"",
    firstInstDate: json["firstInstDate"]??"",
    noOfInsts: json["noOfInsts"]??"",
    totalDueAmt: json["totalDueAmt"]??"",
    totalDueCnt: json["totalDueCnt"]??"",
    totalRecdAmt: json["totalRecdAmt"]??"",
    totalRecdCnt: json["totalRecdCnt"]??"",
    instsAmtDue: json["instsAmtDue"]??"",
    nofInstDue: json["nofInstDue"]??"",
    instData: json["instData"]??"",
    toBeDueAmt: json["toBeDueAmt"]??"",
    toBeDueDate: json["toBeDueDate"]??"",
    futureDue: json["futureDue"]??"",
    instDueAsOn: json["instDueAsOn"]??"",
    isNachReg: json["isNachReg"]??"",
    dataAsOn: json["dataAsOn"]??"",
    interestAmt: json["interestAmt"]??"",
    schmCode: json["schmCode"]??"",
    errormsg: json["errormsg"]??"",
    isvalide: json["isvalide"]??"",
  );

  Map<String, dynamic> toJson() => {
    "db": db,
    "dbName": dbName,
    "creator": creator,
    "foCode": foCode,
    "partyCd": partyCd,
    "custName": custName,
    "mobile": mobile,
    "fhName": fhName,
    "cityCode": cityCode,
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
    "instData": instData,
    "toBeDueAmt": toBeDueAmt,
    "toBeDueDate": toBeDueDate,
    "futureDue": futureDue,
    "instDueAsOn": instDueAsOn,
    "isNachReg": isNachReg,
    "dataAsOn": dataAsOn,
    "interestAmt": interestAmt,
    "schmCode": schmCode,
    "errormsg": errormsg,
    "isvalide": isvalide,
  };
}
