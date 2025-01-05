class PlaceCodesModel {
  final int statuscode;
  final String message;
  final List<PlaceData> data;

  PlaceCodesModel({
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory PlaceCodesModel.fromJson(Map<String, dynamic> json) {
    return PlaceCodesModel(
      statuscode: json['statuscode'] as int,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => PlaceData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statuscode': statuscode,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class PlaceData {
  final String? distCode;
  final String? subDistCode;
  final String? errorMsg;
  final String? subDistName;
  final String? distName;
  final String? villageCode;
  final String? villageName;
  final String? stateCode;
  final String? cityCode;
  final String? cityName;

  PlaceData({
    required this.distCode,
    this.subDistCode,
    this.errorMsg,
    this.subDistName,
    required this.distName,
    this.villageCode,
    this.villageName,
    required this.stateCode,
    this.cityCode,
    this.cityName,
  });

  factory PlaceData.fromJson(Map<String, dynamic> json) {
    return PlaceData(
      distCode: json['disT_CODE'] as String?,
      subDistCode: json['suB_DIST_CODE'] as String?,
      errorMsg: json['errormsg'] as String?,
      subDistName: json['suB_DIST_NAME'] as String?,
      distName: json['disT_NAME'] as String?,
      villageCode: json['villagE_CODE'] as String?,
      villageName: json['villagE_NAME'] as String?,
      stateCode: json['statE_CODE'] as String?,
      cityCode: json['citY_CODE'] as String?,
      cityName: json['citY_NAME'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disT_CODE': distCode,
      'suB_DIST_CODE': subDistCode,
      'errormsg': errorMsg,
      'suB_DIST_NAME': subDistName,
      'disT_NAME': distName,
      'villagE_CODE': villageCode,
      'villagE_NAME': villageName,
      'statE_CODE': stateCode,
      'citY_CODE': cityCode,
      'citY_NAME': cityName,
    };
  }
}
