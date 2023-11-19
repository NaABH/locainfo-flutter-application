import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/location/geolocation_provider.dart';

class LocationProvider implements GeoLocationProvider {
  LocationProvider();

  @override
  Future<Position?> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
