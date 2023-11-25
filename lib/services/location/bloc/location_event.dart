import 'package:flutter/foundation.dart';

@immutable
abstract class LocationEvent {
  const LocationEvent();
}

class LocationEventLoadPosition extends LocationEvent {}

// class UpdateLocationEvent extends LocationEvent {
//   final Position position;
//   const UpdateLocationEvent({required this.position});
//
//   @override
//   List<Object?> get props => [position];
// }
