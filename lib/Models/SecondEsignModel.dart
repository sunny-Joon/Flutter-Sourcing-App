// To parse this JSON data, do
//
//     final secondEsignModel = secondEsignModelFromJson(jsonString);

import 'dart:convert';

SecondEsignModel secondEsignModelFromJson(String str) => SecondEsignModel.fromJson(json.decode(str));

String secondEsignModelToJson(SecondEsignModel data) => json.encode(data.toJson());

class SecondEsignModel {
  int statuscode;
  String message;
  List<SecondEsignDataModel> data;

  SecondEsignModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory SecondEsignModel.fromJson(Map<String, dynamic> json) => SecondEsignModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<SecondEsignDataModel>.from(json["data"].map((x) => SecondEsignDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SecondEsignDataModel {
  int id;
  String fiCode;
  String creator;
  double sanctionedAmt;
  String remarks;
  String dtFin;
  String dtStart;
  int schemeId;
  String fName;
  String mName;
  String lName;
  String fatheRFirstName;
  String fatheRMiddleName;
  String fatheRLastName;
  String description;
  int period;
  double rate;
  String aadharNo;
  String addr;
  String pPhone;
  String branchCode;
  String borrSignStatus;
  String kycuuid;
  String groupCode;
  String dob;
  String pCity;
  String pState;
  String pPincode;
  String panNo;
  String gender;
  int bankSanctionId;
  int income;
  int expenses;
  String loanReason;
  String voterId;
  int loanAmount;
  int loanDuration;
  bool isvalid;
  String errormsg;
  String profilePic;
  String groupName;

  SecondEsignDataModel({
    required this.id,
    required this.fiCode,
    required this.creator,
    required this.sanctionedAmt,
    required this.remarks,
    required this.dtFin,
    required this.dtStart,
    required this.schemeId,
    required this.fName,
    required this.mName,
    required this.lName,
    required this.fatheRFirstName,
    required this.fatheRMiddleName,
    required this.fatheRLastName,
    required this.description,
    required this.period,
    required this.rate,
    required this.aadharNo,
    required this.addr,
    required this.pPhone,
    required this.branchCode,
    required this.borrSignStatus,
    required this.kycuuid,
    required this.groupCode,
    required this.dob,
    required this.pCity,
    required this.pState,
    required this.pPincode,
    required this.panNo,
    required this.gender,
    required this.bankSanctionId,
    required this.income,
    required this.expenses,
    required this.loanReason,
    required this.voterId,
    required this.loanAmount,
    required this.loanDuration,
    required this.isvalid,
    required this.errormsg,
    required this.profilePic,
    required this.groupName,
  });

  factory SecondEsignDataModel.fromJson(Map<String, dynamic> json) => SecondEsignDataModel(
    id: json["id"]??0,
    fiCode: json["fiCode"]??"",
    creator: json["creator"]??"",
    sanctionedAmt: json["sanctionedAmt"]??0.0,
    remarks: json["remarks"]??"",
    dtFin: json["dt_Fin"]??"",
    dtStart: json["dt_Start"]??"",
    schemeId: json["schemeId"]??0,
    fName: json["f_Name"]??"",
    mName: json["m_Name"]??"",
    lName: json["l_Name"]??"",
    fatheRFirstName: json["fatheR_FIRST_NAME"]??"",
    fatheRMiddleName: json["fatheR_MIDDLE_NAME"]??"",
    fatheRLastName: json["fatheR_LAST_NAME"]??"",
    description:json["description"]??"",
    period: json["period"]??0,
    rate: json["rate"].toDouble()??0.0,
    aadharNo: json["aadhar_no"]??"",
    addr: json["addr"]??"",
    pPhone: json["p_Phone"]??"",
    branchCode: json["branch_code"]??"",
    borrSignStatus: json["borrSignStatus"]??"",
    kycuuid: json["kycuuid"]??"",
    groupCode: json["group_code"]??"",
    dob: json["dob"]??"",
    pCity: json["p_city"]??"",
    pState: json["p_state"]??"",
    pPincode: json["p_Pincode"]??"",
    panNo: json["pan_no"]??"",
    gender: json["gender"]??"",
    bankSanctionId: json["bankSanctionId"]??0,
    income: json["income"]??0,
    expenses: json["expenses"]??0,
    loanReason: json["loan_Reason"]??"",
    voterId: json["voter_id"]??"",
    loanAmount: json["loan_amount"]??0,
    loanDuration: json["loan_Duration"]??0,
    isvalid: json["isvalid"]??false,
    errormsg: json["errormsg"]??"",
    groupName: json["groupName"]??"",
    profilePic: json["profilePic"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fiCode": fiCode,
    "creator": creator,
    "sanctionedAmt": sanctionedAmt,
    "remarks": remarks,
    "dt_Fin": dtFin,
    "dt_Start": dtStart,
    "schemeId": schemeId,
    "f_Name": fName,
    "m_Name": mName,
    "l_Name": lName,
    "fatheR_FIRST_NAME": fatheRFirstName,
    "fatheR_MIDDLE_NAME": fatheRMiddleName,
    "fatheR_LAST_NAME": fatheRLastName,
    "description": description,
    "period": period,
    "rate": rate,
    "aadhar_no": aadharNo,
    "addr": addr,
    "p_Phone": pPhone,
    "branch_code": branchCode,
    "borrSignStatus": borrSignStatus,
    "kycuuid": kycuuid,
    "group_code": groupCode,
    "dob": dob,
    "p_city": pCity,
    "p_state": pState,
    "p_Pincode": pPincode,
    "pan_no": panNo,
    "gender": gender,
    "bankSanctionId": bankSanctionId,
    "income": income,
    "expenses": expenses,
    "loan_Reason": loanReason,
    "voter_id": voterId,
    "loan_amount": loanAmount,
    "loan_Duration": loanDuration,
    "isvalid": isvalid,
    "errormsg": errormsg,
    "profilePic": profilePic,
    "groupName": groupName,
  };
}

