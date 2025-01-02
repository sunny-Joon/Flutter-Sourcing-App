import 'dart:convert';
class OcrDocsScanningResponse {
  final int statusCode;
  final String message;
  final OcrDocsData data;

  OcrDocsScanningResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OcrDocsScanningResponse.fromJson(Map<String, dynamic> json) {
    return OcrDocsScanningResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: OcrDocsData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class OcrDocsData {
  final String? name;
  final String? dob;
  final String? panNo;
  final String? adharId;
  final String? voterId;
  final String? dlNo;
  final bool isOSV;
  final bool isIdMatched;
  final String? osvName;
  final bool status;
  final String? errorReason;
  final String? errorCode;
  final String? errorMessage;
  final bool isSuccessStatusCode;
  final String? responseContent;

  OcrDocsData({
    this.name,
    this.dob,
    this.panNo,
    this.adharId,
    this.voterId,
    this.dlNo,
    required this.isOSV,
    required this.isIdMatched,
    this.osvName,
    required this.status,
    this.errorReason,
    this.errorCode,
    this.errorMessage,
    required this.isSuccessStatusCode,
    this.responseContent,
  });

  factory OcrDocsData.fromJson(Map<String, dynamic> json) {
    return OcrDocsData(
      name: json['name'],
      dob: json['dob'],
      panNo: json['pan_No'],
      adharId: json['adharId'],
      voterId: json['voterId'],
      dlNo: json['dL_No'],
      isOSV: json['isOSV'],
      isIdMatched: json['isIdMatched'],
      osvName: json['osvName'],
      status: json['status'],
      errorReason: json['error_reason'],
      errorCode: json['error_code'],
      errorMessage: json['error_message'],
      isSuccessStatusCode: json['isSuccessStatusCode'],
      responseContent: json['responseContent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dob': dob,
      'pan_No': panNo,
      'adharId': adharId,
      'voterId': voterId,
      'dL_No': dlNo,
      'isOSV': isOSV,
      'isIdMatched': isIdMatched,
      'osvName': osvName,
      'status': status,
      'error_reason': errorReason,
      'error_code': errorCode,
      'error_message': errorMessage,
      'isSuccessStatusCode': isSuccessStatusCode,
      'responseContent': responseContent,
    };
  }
}
