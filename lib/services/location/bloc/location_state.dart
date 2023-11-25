import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

@immutable
abstract class LocationState {
  const LocationState();
}

class LocationStateInitialise extends LocationState {}

// loaded the location
class LocationStateLoaded extends LocationState with EquatableMixin {
  final Position position;
  LocationStateLoaded({required this.position});

  @override
  List<Object?> get props => [position];
}

class LocationLoadErrorState extends LocationState {}
