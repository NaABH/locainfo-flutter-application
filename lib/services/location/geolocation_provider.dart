import 'package:geolocator/geolocator.dart';

abstract class GeoLocationProvider {
  Future<Position?> getCurrentLocation() async {}

  Future<Position?> getLastKnownLocation() async {}
}
