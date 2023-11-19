import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

@immutable
abstract class LocationState {
  const LocationState();
}

class LocationLoadingState extends LocationState {}

class LocationLoadedState extends LocationState with EquatableMixin {
  final Position position;
  LocationLoadedState({required this.position});

  @override
  List<Object?> get props => [position];
}

class LocationLoadErrorState extends LocationState {}
