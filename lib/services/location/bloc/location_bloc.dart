import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/location/bloc/location_event.dart';
import 'package:locainfo/services/location/bloc/location_state.dart';
import 'package:locainfo/services/location/location_provider.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc(LocationProvider provider) : super(LocationStateInitialise()) {
    // load location
    on<LocationEventLoadPosition>((event, emit) async {
      final Position position = await provider.getCurrentLocation();
      emit(LocationStateLoaded(position: position));
    });

    //   on<UpdateLocationEvent>((event, emit) async {
    //     emit(LocationLoadedState(position: event.position));
    //   });
  }
}
