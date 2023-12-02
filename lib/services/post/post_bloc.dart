import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/cloud_storage/storage_provider.dart';
import 'package:locainfo/services/firestore/database_provider.dart';
import 'package:locainfo/services/location/geolocation_provider.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_exceptions.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/input_validation.dart';
import 'package:locainfo/utilities/post_info_helper.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final DatabaseProvider _databaseProvider;
  final GeoLocationProvider _locationProvider;
  final FirebaseAuthProvider _authProvider;
  final StorageProvider _cloudStorageProvider;

  PostBloc(
    this._databaseProvider,
    this._locationProvider,
    this._authProvider,
    this._cloudStorageProvider,
  ) : super(const PostStateInitial(isLoading: false)) {
    // constant
    late PostState previousState;
    int delayTime = 400;

    // load nearby posts (news page)
    on<PostEventLoadNearbyPosts>((event, emit) async {
      try {
        emit(const PostStateLoadingPosts(
            isLoading: false, loadingText: 'Fetching nearby posts'));
        final position = await _locationProvider.getCurrentLocation();
        final posts = await _databaseProvider.getNearbyPosts(
          position: position,
          currentUserId: _authProvider.currentUser!.id,
        );
        await Future.delayed(Duration(milliseconds: delayTime), () {
          if (posts.isEmpty) {
            emit(const PostStateNoAvailablePost(isLoading: false));
          } else {
            emit(PostStatePostLoaded(
                isLoading: false, posts: posts, currentPosition: position));
          }
        });
      } on Exception catch (e) {
        emit(PostStateLoadError(isLoading: false, exception: e));
      }
    });

    // load bookmark posts (bookmark page)
    on<PostEventLoadBookmarkedPosts>((event, emit) async {
      try {
        emit(const PostStateLoadingPosts(
            isLoading: false, loadingText: 'Fetching bookmarks'));
        final userId = _authProvider.currentUser!.id;
        final posts = await _databaseProvider.getBookmarkedPosts(userId);
        await Future.delayed(Duration(milliseconds: delayTime), () {
          if (posts.isNotEmpty) {
            emit(
                PostStateLoadedBookmarkedPosts(posts: posts, isLoading: false));
          } else {
            emit(const PostStateNoAvailableBookmarkPost(isLoading: false));
          }
        });
      } on Exception catch (e) {
        emit(PostStateLoadError(isLoading: false, exception: e));
      }
    });

    // clear all bookmark (bookmark page)
    on<PostEventClearAllBookmark>((event, emit) async {
      try {
        emit(const PostStateClearingBookmarks(
            isLoading: true, loadingText: 'Clearing all bookmarks'));
        final userId = _authProvider.currentUser!.id;
        await _databaseProvider.clearBookmarkList(currentUserId: userId);
        emit(const PostStateClearingBookmarks(isLoading: false));
        emit(const PostStateClearBookmarkSuccessfully(isLoading: false));
      } on Exception catch (_) {
        emit(const PostStateClearingBookmarks(isLoading: false));
        emit(const PostStateClearBookmarkError(isLoading: false));
      }
    });

    // save previous state (create post page)
    on<PostEventSavePreviousState>((event, emit) {
      previousState = state;
    });

    // (create post page)
    on<PostEventBackToLastState>((event, emit) {
      emit(previousState);
    });

    // initiate create post page (create post page)
    on<PostEventInitialiseCreatePost>((event, emit) async {
      try {
        final position = await _locationProvider.getCurrentLocation();
        emit(PostStateCreatingPost(
          isLoading: false,
          position: position,
          exception: null,
        ));
      } on Exception catch (e) {
        emit(const PostStateCreatingPost(position: null, isLoading: false));
      }
    });

    // create post (create post page)
    on<PostEventCreatePost>((event, emit) async {
      String? imageUrl;
      late final Position position;
      try {
        position = await _locationProvider.getCurrentLocation();
        if (!isInputValid(event.title)) {
          throw TitleCouldNotEmptyPostException();
        }
        if (!isInputValid(event.body)) {
          throw ContentCouldNotEmptyPostException();
        }
        if (event.category == null ||
            !postCategories.containsKey(event.category)) {
          throw InvalidCategoryPostException();
        }
        emit(const PostStateSubmittingPost(
            isLoading: true, loadingText: 'Submitting...'));
        await Future.delayed(const Duration(seconds: 2), () async {
          if (event.image != null) {
            imageUrl =
                await _cloudStorageProvider.uploadPostImage(event.image!);
          } // CouldNotUploadPostImageException
          String locationName =
              await getLocationName(position.latitude, position.longitude);
          Timestamp postedTimestamp = Timestamp.fromDate(DateTime.now());
          await _databaseProvider.createNewPost(
            // CouldNotCreatePostException
            ownerUserId: _authProvider.currentUser!.id,
            ownerUserName: _authProvider.currentUserName!,
            ownerProfilePicUrl: _authProvider.currentUserProfilePicUrl,
            title: event.title,
            body: event.body,
            imageUrl: imageUrl != null ? imageUrl! : null,
            category: event.category!,
            latitude: position.latitude,
            longitude: position.longitude,
            locationName: locationName,
            postedDate: postedTimestamp,
          );
          emit(const PostStateSubmittingPost(isLoading: false));
          emit(const PostStateCreatePostSuccessful(isLoading: false));
        });
      } on Exception catch (e) {
        emit(const PostStateSubmittingPost(isLoading: false));
        emit(PostStateCreatingPost(
            isLoading: false, exception: e, position: position));
      }
    });

    // searching (searching page)
    on<PostEventSearchPostTextChanged>((event, emit) async {
      try {
        if (event.searchText != null) {
          emit(const PostStateSearchLoading(isLoading: true));
          final currentLocation = await _locationProvider.getCurrentLocation();
          final filteredPosts = await _databaseProvider.getSearchPosts(
              event.searchText!,
              _authProvider.currentUser!.id,
              currentLocation);
          emit(PostStateSearchLoaded(
              isLoading: false, filteredPosts: filteredPosts));
        } else {
          return; // do nothing
        }
      } on Exception catch (_) {
        emit(const PostStateSearchError(isLoading: false));
      }
    });

    // Posted Post Page-----------------------------------------------------
    // initialise posted post page (posted post page)
    on<PostEventLoadPostedPosts>((event, emit) async {
      try {
        emit(const PostStateLoadingPosts(
            isLoading: false, loadingText: 'Fetching posted posts'));
        final posts = await _databaseProvider.getPostedPosts(
            currentUserId: _authProvider.currentUser!.id);
        await Future.delayed(Duration(milliseconds: delayTime), () {
          if (posts.isNotEmpty) {
            emit(PostStateLoadedPostedPost(posts: posts, isLoading: false));
          } else {
            emit(const PostStateNoAvailablePostedPost(isLoading: false));
          }
        });
      } on Exception catch (e) {
        emit(const PostStateLoadPostedPostsError(isLoading: false));
      }
    });

    // update a post (update post page)
    on<PostEventUpdatePostContent>((event, emit) async {
      String? imageUrl;
      try {
        if (!isInputValid(event.title)) {
          throw TitleCouldNotEmptyPostException();
        }
        if (!isInputValid(event.body)) {
          throw ContentCouldNotEmptyPostException();
        }
        emit(const PostStateUpdatingPosts(
            isLoading: true, loadingText: 'Updating post'));
        if (event.imageUpdated) {
          if (event.image != null) {
            // got image
            imageUrl =
                await _cloudStorageProvider.uploadPostImage(event.image!);
          }
          await _databaseProvider.updatePostImage(
              documentId: event.postId, imageUrl: imageUrl);
        }
        await _databaseProvider.updatePostTitleContent(
          documentId: event.postId,
          title: event.title,
          text: event.body,
        );
        emit(const PostStateUpdatingPosts(isLoading: false));
        emit(const PostStateUpdatePostSuccessfully(isLoading: false));
      } on Exception catch (e) {
        emit(const PostStateUpdatingPosts(isLoading: false));
        emit(PostStateUpdatePostError(isLoading: false, exception: e));
      }
    });

    // update a post reactions (like, unlike, dislike, remove dislike, bookmark, remove bookmark)
    on<PostEventUpdatePostReactions>((event, emit) async {
      try {
        await _databaseProvider.updatePostReactions(
          documentId: event.documentId,
          currentUserId: _authProvider.currentUser!.id,
          action: event.action,
        );
      } on Exception catch (_) {
        emit(const PostStateUpdateReactionsError(isLoading: false));
      }
    });

    // create a post report (in report page)
    on<PostEventCreateReport>((event, emit) async {
      try {
        emit(const PostStateSubmittingReport(
            isLoading: true, loadingText: 'Submitting...'));
        if (!isInputValid(event.reason)) {
          throw ReasonCouldNotEmptyPostException();
        }

        Timestamp postedTimestamp = Timestamp.fromDate(DateTime.now());
        await _databaseProvider.createNewReport(
          // CouldNotCreateReportException
          reporterId: _authProvider.currentUser!.id,
          postId: event.postId,
          reason: event.reason,
          reportDate: postedTimestamp,
        );
        emit(const PostStateSubmittingReport(isLoading: false));
        emit(const PostStateCreateReportSuccessful(isLoading: false));
      } on Exception catch (e) {
        emit(const PostStateSubmittingReport(isLoading: false));
        emit(PostStateCreateReportError(isLoading: false, exception: e));
      }
    });

    // call then deleting post ( posted post page)
    on<PostEventDeletePost>((event, emit) async {
      try {
        emit(const PostStateDeletingPost(
            isLoading: true, loadingText: 'Deleting'));
        await _databaseProvider.deletePost(documentId: event.documentId);
        emit(const PostStateDeletePostSuccessful(isLoading: false));
      } on Exception catch (e) {
        emit(const PostStateDeleteError(isLoading: false));
      }
    });
  }
}
