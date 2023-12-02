import 'package:geolocator/geolocator.dart';

abstract class LocationEvent {}

class LocationEventStartTracking extends LocationEvent {}

class LocationEventStopTracking extends LocationEvent {}

class LocationEventUpdatePosition extends LocationEvent {
  final Position position;
  LocationEventUpdatePosition(this.position);
}
