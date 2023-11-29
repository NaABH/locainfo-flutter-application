import 'package:geolocator/geolocator.dart';

String getDistanceText(
    Position userPosition, double postLatitude, double postLongitude) {
  double distance = Geolocator.distanceBetween(
    userPosition.latitude,
    userPosition.longitude,
    postLatitude,
    postLongitude,
  );

  return '${distance.toInt()} m away';
}
