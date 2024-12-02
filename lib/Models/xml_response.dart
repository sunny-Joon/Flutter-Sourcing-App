// To parse this JSON data, do
//
//     final xmlResponse = xmlResponseFromJson(jsonString);

import 'dart:convert';

XmlResponse xmlResponseFromJson(String str) => XmlResponse.fromJson(json.decode(str));

String xmlResponseToJson(XmlResponse data) => json.encode(data.toJson());

class XmlResponse {
  String version;
  Content content;
  int statusCode;
  String reasonPhrase;
  List<dynamic> headers;
  List<dynamic> trailingHeaders;
  dynamic requestMessage;
  bool isSuccessStatusCode;

  XmlResponse({
    required this.version,
    required this.content,
    required this.statusCode,
    required this.reasonPhrase,
    required this.headers,
    required this.trailingHeaders,
    required this.requestMessage,
    required this.isSuccessStatusCode,
  });

  factory XmlResponse.fromJson(Map<String, dynamic> json) => XmlResponse(
    version: json["version"],
    content: Content.fromJson(json["content"]),
    statusCode: json["statusCode"],
    reasonPhrase: json["reasonPhrase"],
    headers: List<dynamic>.from(json["headers"].map((x) => x)),
    trailingHeaders: List<dynamic>.from(json["trailingHeaders"].map((x) => x)),
    requestMessage: json["requestMessage"]??"",
    isSuccessStatusCode: json["isSuccessStatusCode"],
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "content": content.toJson(),
    "statusCode": statusCode,
    "reasonPhrase": reasonPhrase,
    "headers": List<dynamic>.from(headers.map((x) => x)),
    "trailingHeaders": List<dynamic>.from(trailingHeaders.map((x) => x)),
    "requestMessage": requestMessage,
    "isSuccessStatusCode": isSuccessStatusCode,
  };
}

class Content {
  List<dynamic> headers;

  Content({
    required this.headers,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    headers: List<dynamic>.from(json["headers"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "headers": List<dynamic>.from(headers.map((x) => x)),
  };
}
