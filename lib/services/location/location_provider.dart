import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/location/geolocation_provider.dart';

class LocationProvider implements GeoLocationProvider {
  LocationProvider();
  late StreamSubscription<Position> _locationStream;

  // start location stream
  Future<void> startLocationStream(Function(Position position) handler) async {
    _locationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15, //update once every 20m
      ),
    ).listen(handler);
  }

  // stop location stream
  Future<void> stopLocationStream() async {
    await _locationStream.cancel();
  }

  // get current location
  @override
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // get last known location (value can be null)
  @override
  Future<Position?> getLastKnownLocation() async {
    return await Geolocator.getLastKnownPosition();
  }
}
