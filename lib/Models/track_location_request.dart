// To parse this JSON data, do
//
//     final trackLocationRequest = trackLocationRequestFromJson(jsonString);

import 'dart:convert';

TrackLocationRequest trackLocationRequestFromJson(String str) => TrackLocationRequest.fromJson(json.decode(str));

String trackLocationRequestToJson(TrackLocationRequest data) => json.encode(data.toJson());

class TrackLocationRequest {
  String userId;
  String deviceId;
  String smCode;
  String latitude;
  String longitude;
  String creator;
  String trackAppVersion;
  String appInBackground;
  String activity;
  int fiId;

  TrackLocationRequest({
    required this.userId,
    required this.deviceId,
    required this.smCode,
    required this.latitude,
    required this.longitude,
    required this.creator,
    required this.trackAppVersion,
    required this.appInBackground,
    required this.activity,
    required this.fiId,
  });

  factory TrackLocationRequest.fromJson(Map<String, dynamic> json) => TrackLocationRequest(
    userId: json["UserId"],
    deviceId: json["DeviceId"],
    smCode: json["SmCode"],
    latitude: json["Latitude"]?.toDouble(),
    longitude: json["Longitude"]?.toDouble(),
    creator: json["Creator"],
    trackAppVersion: json["TrackAppVersion"],
    appInBackground: json["appInBackground"],
    activity: json["Activity"],
    fiId: json["Fi_Id"],
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "DeviceId": deviceId,
    "SmCode": smCode,
    "Latitude": latitude,
    "Longitude": longitude,
    "Creator": creator,
    "TrackAppVersion": trackAppVersion,
    "appInBackground": appInBackground,
    "Activity": activity,
    "Fi_Id": fiId,
  };
}
