import 'dart:convert';

BorrowerListModel borrowerListModelFromJson(String str) => BorrowerListModel.fromJson(json.decode(str));

String borrowerListModelToJson(BorrowerListModel data) => json.encode(data.toJson());

class BorrowerListModel {
  BorrowerListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  int statusCode;
  String message;
  List<BorrowerListDataModel> data;

  factory BorrowerListModel.fromJson(Map<String, dynamic> json) => BorrowerListModel(
    statusCode: json["statusCode"],
    message: json["message"],
    data: List<BorrowerListDataModel>.from(json["data"].map((x) => BorrowerListDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BorrowerListDataModel {
  BorrowerListDataModel({
    required this.code,
    required this.creator,
    required this.sanctionedAmt,
    this.remarks,
    this.dtFin,
    this.dtStart,
    this.schCode,
    required this.fname,
    this.mname,
    required this.lname,
    required this.fFname,
    this.fMname,
    required this.fLname,
    this.description,
    this.period,
    required this.rate,
    required this.aadharid,
    required this.addr,
    required this.pPh3,
    required this.groupCode,
    required this.cityCode,
    this.borrLoanAppSignStatus,
    this.approved,
    this.sel,
  });

  String code;
  String creator;
  double sanctionedAmt;
  String? remarks;
  DateTime? dtFin;
  DateTime? dtStart;
  String? schCode;
  String fname;
  String? mname;
  String lname;
  String fFname;
  String? fMname;
  String fLname;
  String? description;
  String? period;
  int rate;
  String aadharid;
  String addr;
  String pPh3;
  String groupCode;
  String cityCode;
  String? borrLoanAppSignStatus;
  String? approved;
  String? sel;

  factory BorrowerListDataModel.fromJson(Map<String, dynamic> json) => BorrowerListDataModel(
    code: json["code"],
    creator: json["creator"],
    sanctionedAmt: json["sanctionedAmt"].toDouble(),
    remarks: json["remarks"],
    dtFin: json["dt_Fin"] != null ? DateTime.parse(json["dt_Fin"]) : null,
    dtStart: json["dt_Start"] != null ? DateTime.parse(json["dt_Start"]) : null,
    schCode: json["schCode"],
    fname: json["fname"],
    mname: json["mname"],
    lname: json["lname"],
    fFname: json["f_fname"],
    fMname: json["f_mname"],
    fLname: json["f_lname"],
    description: json["description"],
    period: json["period"],
    rate: json["rate"],
    aadharid: json["aadharid"],
    addr: json["addr"],
    pPh3: json["p_ph3"],
    groupCode: json["groupCode"],
    cityCode: json["cityCode"],
    borrLoanAppSignStatus: json["borrLoanAppSignStatus"],
    approved: json["approved"],
    sel: json["sel"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "creator": creator,
    "sanctionedAmt": sanctionedAmt,
    "remarks": remarks,
    "dt_Fin": dtFin?.toIso8601String(),
    "dt_Start": dtStart?.toIso8601String(),
    "schCode": schCode,
    "fname": fname,
    "mname": mname,
    "lname": lname,
    "f_fname": fFname,
    "f_mname": fMname,
    "f_lname": fLname,
    "description": description,
    "period": period,
    "rate": rate,
    "aadharid": aadharid,
    "addr": addr,
    "p_ph3": pPh3,
    "groupCode": groupCode,
    "cityCode": cityCode,
    "borrLoanAppSignStatus": borrLoanAppSignStatus,
    "approved": approved,
    "sel": sel,
  };
}
