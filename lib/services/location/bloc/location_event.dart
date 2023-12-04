import 'package:geolocator/geolocator.dart';

// location event that may happen within the application
abstract class LocationEvent {}

class LocationEventStartTracking extends LocationEvent {}

class LocationEventStopTracking extends LocationEvent {}

class LocationEventUpdatePosition extends LocationEvent {
  final Position position;
  LocationEventUpdatePosition(this.position);
}
