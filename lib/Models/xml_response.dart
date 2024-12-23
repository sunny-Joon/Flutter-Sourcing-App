// To parse this JSON data, do
//
//     final xmlResponse = xmlResponseFromJson(jsonString);

import 'dart:convert';

XmlResponse xmlResponseFromJson(String str) => XmlResponse.fromJson(json.decode(str));

String xmlResponseToJson(XmlResponse data) => json.encode(data.toJson());

class XmlResponse {
  ResponseMessage responseMessage;
  String validationMessage;

  XmlResponse({
    required this.responseMessage,
    required this.validationMessage,
  });

  factory XmlResponse.fromJson(Map<String, dynamic> json) => XmlResponse(
    responseMessage: ResponseMessage.fromJson(json["responseMessage"]),
    validationMessage: json["validationMessage"],
  );

  Map<String, dynamic> toJson() => {
    "responseMessage": responseMessage.toJson(),
    "validationMessage": validationMessage,
  };
}

class ResponseMessage {
  String version;
  Content content;
  int statusCode;
  String reasonPhrase;
  List<dynamic> headers;
  List<dynamic> trailingHeaders;
  String? requestMessage;
  bool isSuccessStatusCode;

  ResponseMessage({
    required this.version,
    required this.content,
    required this.statusCode,
    required this.reasonPhrase,
    required this.headers,
    required this.trailingHeaders,
    required this.requestMessage,
    required this.isSuccessStatusCode,
  });

  factory ResponseMessage.fromJson(Map<String, dynamic> json) => ResponseMessage(
    version: json["version"],
    content: Content.fromJson(json["content"]),
    statusCode: json["statusCode"],
    reasonPhrase: json["reasonPhrase"],
    headers: List<dynamic>.from(json["headers"].map((x) => x)),
    trailingHeaders: List<dynamic>.from(json["trailingHeaders"].map((x) => x)),
    requestMessage: json["requestMessage"],
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
  List<Headers> headers;

  Content({
    required this.headers,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    headers: List<Headers>.from(json["headers"].map((x) => Headers.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "headers": List<dynamic>.from(headers.map((x) => x.toJson())),
  };
}

class Headers {
  String key;
  List<dynamic> value;

  Headers({
    required this.key,
    required this.value,
  });

  factory Headers.fromJson(Map<String, dynamic> json) => Headers(
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}
