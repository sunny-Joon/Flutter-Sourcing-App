import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class currentLocation {
  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String address = "${place.name},${place.subLocality},${place.administrativeArea}, ${place.locality}";
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
      };
    } catch (e) {
      print("Error getting current location: $e");
      return {};
    }
  }
}