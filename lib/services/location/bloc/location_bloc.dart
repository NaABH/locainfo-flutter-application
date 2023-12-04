import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/location/bloc/location_event.dart';
import 'package:locainfo/services/location/geolocation_provider.dart';

// bloc to control the location service
class LocationBloc extends Bloc<LocationEvent, Position> {
  final GeoLocationProvider _locationProvider;
  StreamSubscription<Position>? _positionStreamSubscription;

  LocationBloc(this._locationProvider)
      : super(
          Position(
            longitude: 0,
            latitude: 0,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          ),
        ) {
    // start live location tracking (used in home page)
    on<LocationEventStartTracking>((event, emit) async {
      _locationProvider.getCurrentLocation();
      _positionStreamSubscription?.cancel();
      _positionStreamSubscription =
          _locationProvider.getLocationStream().listen(
        (Position position) {
          add(LocationEventUpdatePosition(position));
        },
      );
    });

    // stop live location tracking (after home page dispose)
    on<LocationEventStopTracking>((event, emit) {
      _positionStreamSubscription?.cancel();
      _positionStreamSubscription = null;
    });

    // update the position
    on<LocationEventUpdatePosition>((event, emit) {
      emit(event.position);
    });
  }

  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    return super.close();
  }
}
