import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/location/location_provider.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';
import 'package:locainfo/services/post_bloc/post_exceptions.dart';
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
  ) : super(const PostStateInitial(isLoading: true)) {
    on<PostEventLoadNearbyPosts>((event, emit) async {
      emit(const PostStateLoadingPosts(isLoading: false));
      try {
        final position = await _locationProvider.getCurrentLocation();
        final posts = await _databaseProvider.getNearbyPosts2(
          position: position,
          currentUserId: _authProvider.currentUser!.id,
        );
        if (posts.isEmpty) {
          emit(const PostStateNoAvailablePost(isLoading: false));
        } else {
          emit(PostStateLoaded(isLoading: false, posts: posts));
        }
      } on Exception catch (e) {
        emit(const PostStateLoadError(isLoading: false));
      }
    });

    on<PostEventLoadPostedPosts>((event, emit) async {
      emit(const PostStateLoadingPosts(isLoading: false));
      final userId = _authProvider.currentUser!.id;
      final posts =
          await _databaseProvider.getPostedPosts(currentUserId: userId);
      if (posts.isNotEmpty) {
        emit(PostStateLoaded(posts: posts, isLoading: false));
      } else {
        emit(const PostStateNoAvailablePost(isLoading: false));
      }
    });

    on<PostEventLoadBookmarkedPosts>((event, emit) {});

    on<PostEventCreatePost>((event, emit) async {
      emit(const PostStateSubmittingPost(
          isLoading: true, loadingText: 'Submitting...'));
      try {
        if (event.title.trim().isEmpty ||
            RegExp(r'^[0-9\W_]').hasMatch(event.title)) {
          throw TitleCouldNotEmptyPostException();
        }
        if (event.body.trim().isEmpty ||
            RegExp(r'^[0-9\W_]').hasMatch(event.body)) {
          throw ContentCouldNotEmptyPostException();
        }
        if (event.category == null || !categories.containsKey(event.category)) {
          throw CategoryInvalidPostException();
        }

        final position = await _locationProvider
            .getCurrentLocation(); // CouldNotGetLocationException
        String locationName =
            await getLocationName(position.latitude, position.longitude);
        Timestamp postedTimestamp = Timestamp.fromDate(DateTime.now());
        await _databaseProvider.createNewPost(
          // CouldNotCreatePostException
          ownerUserId: _authProvider.currentUser!.id,
          ownerUserName: _authProvider.currentUserName!,
          title: event.title,
          body: event.body,
          category: event.category!,
          latitude: position.latitude,
          longitude: position.longitude,
          locationName: locationName,
          postedDate: postedTimestamp,
        );
        emit(const PostStateCreatePostSuccessful(isLoading: false));
      } on Exception catch (e) {
        emit(PostStateCreatingPost(
            isLoading: false, exception: e, position: null));
      }
    });

    on<PostEventCreatingPost>((event, emit) async {
      final position = await _locationProvider.getCurrentLocation();
      emit(PostStateCreatingPost(
        isLoading: false,
        position: position,
        exception: null,
      ));
    });

    on<PostEventUpdatePostLike>((event, emit) async {
      await _databaseProvider.updatePostLike(
        documentId: event.documentId,
        currentUserId: _authProvider.currentUser!.id,
        action: event.action,
      );
    });

    on<PostEventUpdatePostDislike>((event, emit) async {
      await _databaseProvider.updatePostDislike(
        documentId: event.documentId,
        currentUserId: _authProvider.currentUser!.id,
        action: event.action,
      );
    });

    on<PostEventUpdateBookmarkList>((event, emit) async {
      await _databaseProvider.updateBookmarkList(
        documentId: event.documentId,
        currentUserId: _authProvider.currentUser!.id,
        action: event.action,
      );
    });
  }
}
