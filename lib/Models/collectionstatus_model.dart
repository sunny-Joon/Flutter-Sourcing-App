// To parse this JSON data, do
//
//     final collectionStatusModel = collectionStatusModelFromJson(jsonString);

import 'dart:convert';

CollectionStatusModel collectionStatusModelFromJson(String str) => CollectionStatusModel.fromJson(json.decode(str));

String collectionStatusModelToJson(CollectionStatusModel data) => json.encode(data.toJson());

class CollectionStatusModel {
  int statuscode;
  String message;
  CollectionStatusDataModel data;

  CollectionStatusModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory CollectionStatusModel.fromJson(Map<String, dynamic> json) => CollectionStatusModel(
    statuscode: json["statuscode"],
    message: json["message"],
    data: CollectionStatusDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "message": message,
    "data": data.toJson(),
  };
}

class CollectionStatusDataModel {
  List<Emi> emis;
  List<EmiCollection> emiCollections;

  CollectionStatusDataModel({
    required this.emis,
    required this.emiCollections,
  });

  factory CollectionStatusDataModel.fromJson(Map<String, dynamic> json) => CollectionStatusDataModel(
    emis: List<Emi>.from(json["emis"].map((x) => Emi.fromJson(x))),
    emiCollections: List<EmiCollection>.from(json["emiCollections"].map((x) => EmiCollection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "emis": List<dynamic>.from(emis.map((x) => x.toJson())),
    "emiCollections": List<dynamic>.from(emiCollections.map((x) => x.toJson())),
  };
}

class EmiCollection {
  int cr;
  DateTime vdate;

  EmiCollection({
    required this.cr,
    required this.vdate,
  });

  factory EmiCollection.fromJson(Map<String, dynamic> json) => EmiCollection(
    cr: json["cr"],
    vdate: DateTime.parse(json["vdate"]),
  );

  Map<String, dynamic> toJson() => {
    "cr": cr,
    "vdate": vdate.toIso8601String(),
  };
}

class Emi {
  int amt;
  DateTime pvNRcpDt;

  Emi({
    required this.amt,
    required this.pvNRcpDt,
  });

  factory Emi.fromJson(Map<String, dynamic> json) => Emi(
    amt: json["amt"],
    pvNRcpDt: DateTime.parse(json["pvN_RCP_DT"]),
  );

  Map<String, dynamic> toJson() => {
    "amt": amt,
    "pvN_RCP_DT": pvNRcpDt.toIso8601String(),
  };
}
