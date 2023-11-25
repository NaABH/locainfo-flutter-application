import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/location/location_provider.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';
import 'package:locainfo/services/post_bloc/post_state.dart';
import 'package:locainfo/utilities/address_converter.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final FireStoreProvider _databaseProvider;
  final LocationProvider _locationProvider;
  final FirebaseAuthProvider _authProvider;

  PostBloc(
    this._databaseProvider,
    this._locationProvider,
    this._authProvider,
  ) : super(const PostStateInitial()) {
    on<PostEventLoadNearbyPosts>((event, emit) async {
      emit(const PostStateLoadingPosts());
      final position = await _locationProvider.getCurrentLocation();
      final posts = await _databaseProvider.getNearbyPosts2(
        position: position,
      );
      if (posts.isEmpty) {
        emit(const PostStateNoAvailablePost());
      } else {
        emit(PostStateLoaded(posts));
      }
    });

    on<PostEventLoadPostedPosts>((event, emit) async {
      emit(const PostStateLoadingPosts());
      final userId = _authProvider.currentUser!.id;
      final posts = await _databaseProvider.getPostedPosts(ownerUserId: userId);
      if (posts.isNotEmpty) {
        emit(PostStateLoaded(posts));
      } else {
        emit(const PostStateNoAvailablePost());
      }
    });

    on<PostEventCreatePost>((event, emit) async {
      emit(const PostStateCreatingPost());
      try {
        final position = await _locationProvider.getCurrentLocation();
        String locationName =
            await getLocationName(position.latitude, position.longitude);
        DateTime postedTime = DateTime.now();
        Timestamp postedTimestamp = Timestamp.fromDate(postedTime);
        await _databaseProvider.createNewPost(
          ownerUserId: _authProvider.currentUser!.id,
          ownerUserName: _authProvider.currentUserName!,
          title: event.title,
          body: event.body,
          category: event.category,
          latitude: position.latitude,
          longitude: position.longitude,
          locationName: locationName,
          postedDate: postedTimestamp,
        );
        emit(const PostStateCreatePostSuccessful());
      } on Exception catch (e) {
        emit(PostStateCreatePostFail(e));
      }
    });

    on<PostEventCreatePostInitialise>((event, emit) async {
      emit(const PostStateLoadingCurrentLocation());
      final position = await _locationProvider.getCurrentLocation();
      emit(PostStateWantCreatePost(position));
    });
  }
}
