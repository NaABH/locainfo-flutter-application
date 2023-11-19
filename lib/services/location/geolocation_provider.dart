import 'package:geolocator/geolocator.dart';

abstract class GeoLocationProvider {
  Future<Position?> getCurrentLocation() async {}
}
