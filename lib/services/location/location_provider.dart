import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/location/geolocation_provider.dart';
import 'package:locainfo/services/location/location_exceptions.dart';
import 'package:locainfo/utilities/toast_message.dart';

// implementation of geo location provider
class LocationProvider implements GeoLocationProvider {
  // singleton
  static final LocationProvider _shared = LocationProvider._sharedInstance();
  LocationProvider._sharedInstance();
  factory LocationProvider() => _shared;

  // constant
  int minDistanceToUpdateOnce = 10;
  int minTimeToUpdateOnceIfNoMove = 20;

  // get current location
  @override
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showToastMessage('Please enable location permission.');
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showToastMessage('Application quiting...');
        SystemNavigator.pop(); // Exit the app
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
    } on Exception catch (_) {
      throw CouldNotGetLocationException();
    }
  }

  // get last known location (value can be null)
  @override
  Future<Position?> getLastKnownLocation() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } on Exception catch (_) {
      throw CouldNotGetLastKnownLocationException();
    }
  }

  // start live location update (stream)
  @override
  Stream<Position> getLocationStream() {
    try {
      return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: minDistanceToUpdateOnce,
            timeLimit: Duration(seconds: minTimeToUpdateOnceIfNoMove)),
      );
    } on Exception catch (_) {
      throw CouldNotGetLiveLocationException();
    }
  }
}
