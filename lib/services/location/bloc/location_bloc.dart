import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/location/bloc/location_event.dart';
import 'package:locainfo/services/location/bloc/location_state.dart';
import 'package:locainfo/services/location/location_provider.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc(LocationProvider provider) : super(LocationLoadingState()) {
    // load location
    on<LoadLocationEvent>((event, emit) async {
      final Position? position = await provider.getCurrentLocation();
      emit(LocationLoadedState(position: position!));
    });

    on<UpdateLocationEvent>((event, emit) async {
      emit(LocationLoadedState(position: event.position));
    });
  }
}

//   @override
//   Stream<LocationState> mapEventToState(
//     LocationEvent event,
//   ) async* {
//     if (event is LoadLocationEvent) {
//       yield* _mapLocationToState();
//     } else if (event is UpdateLocationEvent) {
//       yield* _mapUpdateLocationToState(event);
//     }
//   }
//
//   Stream<LocationState> _mapLocationToState() async* {
//     _locationSubscription?.cancel();
//     final Position? position = await _locationProvider.getCurrentLocation();
//
//     add(UpdateLocationEvent(position: position!));
//   }
//
//   Stream<LocationState> _mapUpdateLocationToState(
//       UpdateLocationEvent event) async* {
//     yield LocationLoaded(position: event.position);
//   }
//
//   @override
//   Future<void> close() {
//     _locationSubscription?.cancel();
//     return super.close();
//   }
// }
