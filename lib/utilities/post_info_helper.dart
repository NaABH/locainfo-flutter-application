import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// Functions to help to get the information required to be display for a post

// Function to get the location name based on latitude and longitude
Future<String> getLocationName(double latitude, double longitude) async {
  List<Placemark> placeMarks =
      await placemarkFromCoordinates(latitude, longitude);
  Placemark place = placeMarks[0];
  return place.thoroughfare.toString();
}

// Function to get the distance from the location given
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

// Function to get the time ago text for the post
String getDateFromNowText(DateTime postedDate) {
  final Duration difference = DateTime.now().difference(postedDate);
  if (difference.inDays > 365) {
    return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? "year" : "years"} ago';
  } else if (difference.inDays > 30) {
    return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? "month" : "months"} ago';
  } else if (difference.inDays > 7) {
    return '${(difference.inDays / 7).floor()} ${(difference.inDays / 7).floor() == 1 ? "week" : "weeks"} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? "day" : "days"} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"} ago';
  } else {
    return 'just now';
  }
}
