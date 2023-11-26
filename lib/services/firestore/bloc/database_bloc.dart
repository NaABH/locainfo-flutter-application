import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/firestore/bloc/database_event.dart';
import 'package:locainfo/services/firestore/bloc/database_state.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/location/bloc/location_bloc.dart';
import 'package:locainfo/services/location/bloc/location_state.dart';

import '../../location/bloc/location_event.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  Position? currentPosition;
  late StreamSubscription locationSubscription;

  DatabaseBloc(FireStoreProvider databaseProvider, LocationBloc locationBloc)
      : super(const DatabaseStateUninitialized()) {
    locationSubscription = locationBloc.stream.listen((state) {
      if (state is LocationStateLoaded) {
        currentPosition = state.position;
      }
    });

    on<DatabaseEventLoadNewsPagePost>((event, emit) async {
      emit(const DatabaseStateLoadingPost());
      locationBloc.add(LocationEventLoadPosition());
      final locationState = await locationBloc.stream
          .firstWhere((state) => state is LocationStateLoaded);
      if (locationState is LocationStateLoaded) {
        currentPosition = locationState.position;
        final posts = await databaseProvider.getNearbyPosts(
            userLat: currentPosition!.latitude,
            userLng: currentPosition!.longitude,
            currentUserId: FirebaseAuthProvider().currentUser!.id);
        emit(DatabaseStateNewsPagePostFetched(posts: posts));
      } else {
        print('LocationStateLoaded not received');
      }
    });

    on<DatabaseEventCreatePost>((event, emit) async {
      try {
        await databaseProvider.createNewPost1(
          ownerUserId: event.ownerUserId,
          ownerUserName: event.ownerUserName,
          title: event.title,
          body: event.body,
          category: event.category,
          latitude: event.latitude,
          longitude: event.longitude,
          postedDate: event.postedDate,
        );
      } on Exception catch (e) {}
    });

    @override
    Future<void> close() {
      locationSubscription.cancel();
      return super.close();
    }
  }
}
