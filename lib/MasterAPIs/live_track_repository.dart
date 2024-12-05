import 'package:dio/dio.dart';
import 'package:flutter_sourcing_app/api_service.dart';
import 'package:flutter_sourcing_app/global_class.dart';

import '../Models/track_location_request.dart';
import '../utils/current_location.dart';


class LiveTrackRepository {
  late final ApiService apiService;
  var _latitude=0.0;
  var _longitude=0.0;
  LiveTrackRepository();

  Future<bool> saveLivetrackData( String smCode ,String activity, int fiId) async {
    currentLocation _locationService = currentLocation();
    try {
      Map<String, dynamic> locationData =
      await _locationService.getCurrentLocation();

      _latitude = locationData['latitude'];
      _longitude = locationData['longitude'];

    } catch (e) {
      print("Error getting current location: $e");

    }
    final request = TrackLocationRequest(

      userId: GlobalClass.userName,
      deviceId: GlobalClass.deviceId,
      smCode: smCode,
      latitude: _latitude.toString(),
      longitude: _longitude.toString(),
      creator: GlobalClass.creator,
      trackAppVersion: GlobalClass.appVersion!,
      appInBackground: "No",
      activity: activity,
      fiId: fiId,
    );

    apiService =ApiService.create(baseUrl: ApiConfig.baseUrl1);
    try {
      final response = await apiService.createLiveTrack(
          request,
        GlobalClass.dbName,
        GlobalClass.token,


      );
      if(response.statuscode==200){
        int id=response.data[0].fiId;
        if(id==1 || id==-2){
          return true;
        }

      }
      print("CKYC Response $response");
      return false;
      // If the response is successful, return true

    } catch (e) {
      // Handle error
      print("CKYC Error occurred: $e");
      return false;

    }
  }
}
