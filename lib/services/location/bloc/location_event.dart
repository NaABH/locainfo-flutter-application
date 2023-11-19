import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

@immutable
abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocationEvent extends LocationEvent {}

class UpdateLocationEvent extends LocationEvent {
  final Position position;
  UpdateLocationEvent({required this.position});

  @override
  List<Object?> get props => [position];
}
