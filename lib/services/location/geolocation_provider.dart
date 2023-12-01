import 'package:geolocator/geolocator.dart';

abstract class GeoLocationProvider {
  // Function to get current location
  Future<Position?> getCurrentLocation();
  // Function to get last known location
  Future<Position?> getLastKnownLocation();
  // Function to get live location update
  Stream<Position> getLocationStream();
}
