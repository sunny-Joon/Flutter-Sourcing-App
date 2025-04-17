// To parse this JSON data, do
//
//     final finoModel = finoModelFromJson(jsonString);

import 'dart:convert';

FinoModel finoModelFromJson(String str) => FinoModel.fromJson(json.decode(str));

String finoModelToJson(FinoModel data) => json.encode(data.toJson());

class FinoModel {
  String errorCode;
  String responseCode;
  String responseDescription;
  String kycResCode;
  String kycResRet;
  DateTime kycResTs;
  DateTime kycResTtl;
  String kycResTxn;
  String kycResMapperId;
  String kycResAdvResp;
  String kycResRar;
  String uidDataTkn;
  String uidDataUid;
  String poiDob;
  String poiGender;
  String poiName;
  String poaCo;
  String poaCountry;
  String poaDist;
  String poaHouse;
  String poaLoc;
  String poaPc;
  String poaState;
  String poaStreet;
  String poaVtc;
  String lDataCo;
  String lDataCountry;
  String lDataDist;
  String lDataHouse;
  String lDataLang;
  String lDataLoc;
  String lDataName;
  String lDataPc;
  String lDataState;
  String lDataStreet;
  String lDataVtc;
  String uidDataPht;

  FinoModel({
    required this.errorCode,
    required this.responseCode,
    required this.responseDescription,
    required this.kycResCode,
    required this.kycResRet,
    required this.kycResTs,
    required this.kycResTtl,
    required this.kycResTxn,
    required this.kycResMapperId,
    required this.kycResAdvResp,
    required this.kycResRar,
    required this.uidDataTkn,
    required this.uidDataUid,
    required this.poiDob,
    required this.poiGender,
    required this.poiName,
    required this.poaCo,
    required this.poaCountry,
    required this.poaDist,
    required this.poaHouse,
    required this.poaLoc,
    required this.poaPc,
    required this.poaState,
    required this.poaStreet,
    required this.poaVtc,
    required this.lDataCo,
    required this.lDataCountry,
    required this.lDataDist,
    required this.lDataHouse,
    required this.lDataLang,
    required this.lDataLoc,
    required this.lDataName,
    required this.lDataPc,
    required this.lDataState,
    required this.lDataStreet,
    required this.lDataVtc,
    required this.uidDataPht,
  });

  factory FinoModel.fromJson(Map<String, dynamic> json) => FinoModel(
    errorCode: json["errorCode"],
    responseCode: json["responseCode"],
    responseDescription: json["responseDescription"],
    kycResCode: json["KycRes_code"],
    kycResRet: json["KycRes_ret"],
    kycResTs: DateTime.parse(json["KycRes_ts"]),
    kycResTtl: DateTime.parse(json["KycRes_ttl"]),
    kycResTxn: json["KycRes_txn"],
    kycResMapperId: json["KycRes_Mapper_ID"],
    kycResAdvResp: json["KycRes_ADV_Resp"],
    kycResRar: json["KycRes_Rar"],
    uidDataTkn: json["UidData_tkn"],
    uidDataUid: json["UidData_uid"],
    poiDob: json["Poi_dob"],
    poiGender: json["Poi_gender"],
    poiName: json["Poi_name"],
    poaCo: json["Poa_co"],
    poaCountry: json["Poa_country"],
    poaDist: json["Poa_dist"],
    poaHouse: json["Poa_house"],
    poaLoc: json["Poa_loc"],
    poaPc: json["Poa_pc"],
    poaState: json["Poa_state"],
    poaStreet: json["Poa_street"],
    poaVtc: json["Poa_vtc"],
    lDataCo: json["LData_co"],
    lDataCountry: json["LData_country"],
    lDataDist: json["LData_dist"],
    lDataHouse: json["LData_house"],
    lDataLang: json["LData_lang"],
    lDataLoc: json["LData_loc"],
    lDataName: json["LData_name"],
    lDataPc: json["LData_pc"],
    lDataState: json["LData_state"],
    lDataStreet: json["LData_street"],
    lDataVtc: json["LData_vtc"],
    uidDataPht: json["UidData_Pht"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode,
    "responseCode": responseCode,
    "responseDescription": responseDescription,
    "KycRes_code": kycResCode,
    "KycRes_ret": kycResRet,
    "KycRes_ts": kycResTs.toIso8601String(),
    "KycRes_ttl": kycResTtl.toIso8601String(),
    "KycRes_txn": kycResTxn,
    "KycRes_Mapper_ID": kycResMapperId,
    "KycRes_ADV_Resp": kycResAdvResp,
    "KycRes_Rar": kycResRar,
    "UidData_tkn": uidDataTkn,
    "UidData_uid": uidDataUid,
    "Poi_dob": poiDob,
    "Poi_gender": poiGender,
    "Poi_name": poiName,
    "Poa_co": poaCo,
    "Poa_country": poaCountry,
    "Poa_dist": poaDist,
    "Poa_house": poaHouse,
    "Poa_loc": poaLoc,
    "Poa_pc": poaPc,
    "Poa_state": poaState,
    "Poa_street": poaStreet,
    "Poa_vtc": poaVtc,
    "LData_co": lDataCo,
    "LData_country": lDataCountry,
    "LData_dist": lDataDist,
    "LData_house": lDataHouse,
    "LData_lang": lDataLang,
    "LData_loc": lDataLoc,
    "LData_name": lDataName,
    "LData_pc": lDataPc,
    "LData_state": lDataState,
    "LData_street": lDataStreet,
    "LData_vtc": lDataVtc,
    "UidData_Pht": uidDataPht,
  };
}
