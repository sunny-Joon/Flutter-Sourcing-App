import 'dart:convert';

DatabyAadhaarModel databyAadhaarModelFromJson(String str) => DatabyAadhaarModel.fromJson(json.decode(str));

String databyAadhaarModelToJson(DatabyAadhaarModel data) => json.encode(data.toJson());

class DatabyAadhaarModel {
  int statuscode;
  String message;
  List<DatabyAadhaarDataModel> data;

  DatabyAadhaarModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory DatabyAadhaarModel.fromJson(Map<String, dynamic> json) => DatabyAadhaarModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<DatabyAadhaarDataModel>.from(json["data"].map((x) => DatabyAadhaarDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DatabyAadhaarDataModel {
  int fIId;
  int fiCode;
  String creatorName;
  String aadharNo;
  String customerName;
  String dob;
  String groupCode;
  String branchCode;
  String caseStatus;
  String errormsg;
  String pState;
  bool isvalid;

  DatabyAadhaarDataModel({
    required this.fIId,
    required this.fiCode,
    required this.creatorName,
    required this.aadharNo,
    required this.customerName,
    required this.dob,
    required this.groupCode,
    required this.branchCode,
    required this.caseStatus,
    required this.errormsg,
    required this.pState,
    required this.isvalid,
  });

  factory DatabyAadhaarDataModel.fromJson(Map<String, dynamic> json) => DatabyAadhaarDataModel(
    fIId: json["fI_Id"]??0,
    fiCode: json["fiCode"]??0,
    creatorName: json["creatorName"]??"",
    aadharNo: json["aadhar_no"]??"",
    customerName: json["customerName"]??"",
    dob: json["dob"]??"",
    groupCode: json["group_code"]??"",
    branchCode: json["branch_code"]??"",
    caseStatus: json["caseStatus"]??"",
    errormsg: json["errormsg"]??"",
    pState: json["p_State"]??"",
    isvalid: json["isvalid"]??false,
  );

  Map<String, dynamic> toJson() => {
    "fI_Id": fIId,
    "fiCode": fiCode,
    "creatorName": creatorName,
    "aadhar_no": aadharNo,
    "customerName": customerName,
    "dob": dob,
    "group_code": groupCode,
    "branch_code": branchCode,
    "caseStatus": caseStatus,
    "errormsg": errormsg,
    "p_State": pState,
    "isvalid": isvalid,
  };
}
