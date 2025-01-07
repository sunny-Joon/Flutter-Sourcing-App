// To parse this JSON data, do
//
//     final adhaarModel = adhaarModelFromJson(jsonString);

import 'dart:convert';

AdhaarModel adhaarModelFromJson(String str) => AdhaarModel.fromJson(json.decode(str));

String adhaarModelToJson(AdhaarModel data) => json.encode(data.toJson());

class AdhaarModel {
  int statuscode;
  String message;
  List<AdhaarDataModel> data;

  AdhaarModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory AdhaarModel.fromJson(Map<String, dynamic> json) => AdhaarModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<AdhaarDataModel>.from(json["data"].map((x) => AdhaarDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdhaarDataModel {
  int fiId;
  int fiCode;
  String aadharNo;
  String title;
  String fName;
  String mName;
  String lName;
  String dob;
  String gender;
  String cast;
  String pPhone;
  String fatheRFirstName;
  String fatheRMiddleName;
  String fatheRLastName;
  String spousEFirstName;
  String spousEMiddleName;
  String spousELastName;
  String creator;
  int expense;
  int income;
  String pAddress1;
  String pAddress2;
  String pAddress3;
  String pCity;
  String pState;
  String pPincode;
  bool isMarried;
  String branchCode;
  String groupCode;
  int age;
  int loanAmount;
  String loanDuration;
  int bankSanctionId;
  String relationWithBorrower;
  String loanReason;
  String panNo;
  String dl;
  String voterId;
  String passport;
  int isAadharVerified;
  int isPhnnoVerified;
  int isNameVerify;
  String dlExpireDate;
  String passportExpireDate;
  String panName;
  String voterName;
  String aadharName;
  String drivingLicName;
  String bankAc;
  String subDistrict;
  String village;
  String villagECode;
  String citYCode;
  String suBDistCode;
  String disTCode;
  String statECode;
  String errormsg;
  bool isvalid;

  AdhaarDataModel({
    required this.fiId,
    required this.fiCode,
    required this.aadharNo,
    required this.title,
    required this.fName,
    required this.mName,
    required this.lName,
    required this.dob,
    required this.gender,
    required this.cast,
    required this.pPhone,
    required this.fatheRFirstName,
    required this.fatheRMiddleName,
    required this.fatheRLastName,
    required this.spousEFirstName,
    required this.spousEMiddleName,
    required this.spousELastName,
    required this.creator,
    required this.expense,
    required this.income,
    required this.pAddress1,
    required this.pAddress2,
    required this.pAddress3,
    required this.pCity,
    required this.pState,
    required this.pPincode,
    required this.isMarried,
    required this.branchCode,
    required this.groupCode,
    required this.age,
    required this.loanAmount,
    required this.loanDuration,
    required this.bankSanctionId,
    required this.relationWithBorrower,
    required this.loanReason,
    required this.panNo,
    required this.dl,
    required this.voterId,
    required this.passport,
    required this.isAadharVerified,
    required this.isPhnnoVerified,
    required this.isNameVerify,
    required this.dlExpireDate,
    required this.passportExpireDate,
    required this.panName,
    required this.voterName,
    required this.aadharName,
    required this.drivingLicName,
    required this.bankAc,
    required this.subDistrict,
    required this.village,
    required this.villagECode,
    required this.citYCode,
    required this.suBDistCode,
    required this.disTCode,
    required this.statECode,
    required this.errormsg,
    required this.isvalid,
  });

  factory AdhaarDataModel.fromJson(Map<String, dynamic> json) => AdhaarDataModel(
    fiId: json["fi_ID"]??0,
    fiCode: json["fiCode"]??0,
    aadharNo: json["aadhar_no"]??"",
    title: json["title"]??"",
    fName: json["f_Name"]??"",
    mName: json["m_Name"]??"",
    lName: json["l_Name"]??"",
    dob: json["dob"]??"",
    gender: json["gender"]??"",
    cast: json["cast"]??"",
    pPhone: json["p_Phone"]??"",
    fatheRFirstName: json["fatheR_FIRST_NAME"]??"",
    fatheRMiddleName: json["fatheR_MIDDLE_NAME"]??"",
    fatheRLastName: json["fatheR_LAST_NAME"]??"",
    spousEFirstName: json["spousE_FIRST_NAME"]??"",
    spousEMiddleName: json["spousE_MIDDLE_NAME"]??"",
    spousELastName: json["spousE_LAST_NAME"]??"",
    creator: json["creator"]??"",
    expense: json["expense"]??0,
    income: json["income"]??0,
    pAddress1: json["p_Address1"]??"",
    pAddress2: json["p_Address2"]??"",
    pAddress3: json["p_Address3"]??"",
    pCity: json["p_City"]??"",
    pState: json["p_State"]??"",
    pPincode: json["p_Pincode"]??"",
    isMarried: json["isMarried"]??"",
    branchCode: json["branchCode"]??"",
    groupCode: json["groupCode"]??"",
    age: json["age"]??0,
    loanAmount: json["loan_amount"]??0,
    loanDuration: json["loan_Duration"]??"",
    bankSanctionId: json["bankSanctionId"]??0,
    relationWithBorrower: json["relation_with_Borrower"]??"",
    loanReason: json["loan_Reason"]??"",
    panNo: json["pan_no"]??"",
    dl: json["dl"]??"",
    voterId: json["voter_id"]??"",
    passport: json["passport"]??"",
    isAadharVerified: json["isAadharVerified"]??0,
    isPhnnoVerified: json["is_phnno_verified"]??0,
    isNameVerify: json["isNameVerify"]??0,
    dlExpireDate: json["dlExpireDate"]??"",
    passportExpireDate: json["passportExpireDate"]??"",
    panName: json["pan_Name"]??"",
    voterName: json["voter_Name"]??"",
    aadharName: json["aadhar_Name"]??"",
    drivingLicName: json["drivingLic_Name"]??"",
    bankAc: json["bank_Ac"]??"",
    subDistrict: json["sub_District"]??"",
    village: json["village"]??"",
    villagECode: json["villagE_CODE"]??"",
    citYCode: json["citY_CODE"]??"",
    suBDistCode: json["suB_DIST_CODE"]??"",
    disTCode: json["disT_CODE"]??"",
    statECode: json["statE_CODE"]??"",
    errormsg: json["errormsg"]??"",
    isvalid: json["isvalid"]??false,
  );

  Map<String, dynamic> toJson() => {
    "fi_ID": fiId,
    "fiCode": fiCode,
    "aadhar_no": aadharNo,
    "title": title,
    "f_Name": fName,
    "m_Name": mName,
    "l_Name": lName,
    "dob": dob,
    "gender": gender,
    "cast": cast,
    "p_Phone": pPhone,
    "fatheR_FIRST_NAME": fatheRFirstName,
    "fatheR_MIDDLE_NAME": fatheRMiddleName,
    "fatheR_LAST_NAME": fatheRLastName,
    "spousE_FIRST_NAME": spousEFirstName,
    "spousE_MIDDLE_NAME": spousEMiddleName,
    "spousE_LAST_NAME": spousELastName,
    "creator": creator,
    "expense": expense,
    "income": income,
    "p_Address1": pAddress1,
    "p_Address2": pAddress2,
    "p_Address3": pAddress3,
    "p_City": pCity,
    "p_State": pState,
    "p_Pincode": pPincode,
    "isMarried": isMarried,
    "branchCode": branchCode,
    "groupCode": groupCode,
    "age": age,
    "loan_amount": loanAmount,
    "loan_Duration": loanDuration,
    "bankSanctionId": bankSanctionId,
    "relation_with_Borrower": relationWithBorrower,
    "loan_Reason": loanReason,
    "pan_no": panNo,
    "dl": dl,
    "voter_id": voterId,
    "passport": passport,
    "isAadharVerified": isAadharVerified,
    "is_phnno_verified": isPhnnoVerified,
    "isNameVerify": isNameVerify,
    "dlExpireDate": dlExpireDate,
    "passportExpireDate": passportExpireDate,
    "pan_Name": panName,
    "voter_Name": voterName,
    "aadhar_Name": aadharName,
    "drivingLic_Name": drivingLicName,
    "bank_Ac": bankAc,
    "sub_District": subDistrict,
    "village": village,
    "villagE_CODE": villagECode,
    "citY_CODE": citYCode,
    "suB_DIST_CODE": suBDistCode,
    "disT_CODE": disTCode,
    "statE_CODE": statECode,
    "errormsg": errormsg,
    "isvalid": isvalid,
  };
}
