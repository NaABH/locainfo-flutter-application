import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/cloud_storage/cloudstorage_provider.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/location/location_provider.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_exceptions.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/input_validation.dart';
import 'package:locainfo/utilities/post_info_helper.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final FireStoreProvider _databaseProvider;
  final LocationProvider _locationProvider;
  final FirebaseAuthProvider _authProvider;
  final CloudStorageProvider _cloudStorageProvider;

  PostBloc(
    this._databaseProvider,
    this._locationProvider,
    this._authProvider,
    this._cloudStorageProvider,
  ) : super(const PostStateInitial(isLoading: false)) {
    // load nearby posts (news page)
    on<PostEventLoadNearbyPosts>((event, emit) async {
      try {
        emit(const PostStateLoadingPosts(
            isLoading: true, loadingText: 'Fetching nearby posts...'));
        final position = await _locationProvider.getCurrentLocation();
        final posts = await _databaseProvider.getNearbyPosts(
          position: position,
          currentUserId: _authProvider.currentUser!.id,
        );
        if (posts.isEmpty) {
          emit(const PostStateLoadingPosts(isLoading: false));
          emit(const PostStateNoAvailablePost(isLoading: false));
        } else {
          emit(const PostStateLoadingPosts(isLoading: false));
          emit(PostStatePostLoaded(
              isLoading: false, posts: posts, currentPosition: position));
        }
      } on Exception catch (e) {
        emit(const PostStateLoadingPosts(isLoading: false));
        emit(PostStateLoadError(isLoading: false, exception: e));
      }
    });

    // load bookmark posts (bookmark page)
    on<PostEventLoadBookmarkedPosts>((event, emit) async {
      try {
        emit(const PostStateLoadingPosts(
            isLoading: true, loadingText: 'Fetching bookmarks'));
        final userId = _authProvider.currentUser!.id;
        final posts = await _databaseProvider.getBookmarkedPosts(userId);
        if (posts.isNotEmpty) {
          emit(const PostStateLoadingPosts(isLoading: false));
          emit(PostStateLoadedBookmarkedPosts(posts: posts, isLoading: false));
        } else {
          emit(const PostStateLoadingPosts(isLoading: false));
          emit(const PostStateNoAvailablePost(isLoading: false));
        }
      } on Exception catch (e) {
        emit(const PostStateLoadingPosts(isLoading: false));
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

    // initiate create post page
    on<PostEventCreatingPost>((event, emit) async {
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
        emit(const PostStateSubmittingPost(
            isLoading: true, loadingText: 'Submitting...'));
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
        Future.delayed(const Duration(seconds: 1), () async {
          if (event.image != null) {
            imageUrl =
                await _cloudStorageProvider.uploadPostImage(event.image!);
          } // CouldNotUploadPostImageException
          String locationName =
              await getLocationName(position!.latitude, position!.longitude);
          Timestamp postedTimestamp = Timestamp.fromDate(DateTime.now());
          await _databaseProvider.createNewPost(
            // CouldNotCreatePostException
            ownerUserId: _authProvider.currentUser!.id,
            ownerUserName: _authProvider.currentUserName!,
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

    // initialise profile (profile page)
    on<PostEventInitialiseProfile>((event, emit) async {
      try {
        final user = await _databaseProvider.getUser(
            currentUserId: _authProvider.currentUser!.id);
        emit(PostStateProfileInitialised(isLoading: false, user: user));
      } on Exception catch (_) {
        emit(const PostStateProfileInitialiseFail(isLoading: false));
      }
    });

    // initialise posted post page (posted post page)
    on<PostEventLoadPostedPosts>((event, emit) async {
      try {
        emit(const PostStateLoadingPosts(
            isLoading: true, loadingText: 'Fetching posted posts'));
        final posts = await _databaseProvider.getPostedPosts(
            currentUserId: _authProvider.currentUser!.id);
        if (posts.isNotEmpty) {
          emit(const PostStateLoadingPosts(isLoading: false));
          emit(PostStateLoadedPostedPost(posts: posts, isLoading: false));
        } else {
          emit(const PostStateLoadingPosts(isLoading: false));
          emit(const PostStateNoAvailablePostedPost(isLoading: false));
        }
      } on Exception catch (e) {
        emit(const PostStateLoadingPosts(isLoading: false));
        emit(const PostStateLoadPostedPostsError(isLoading: false));
      }
    });

    // update a post (update post page)
    on<PostEventUpdatePostContent>((event, emit) async {
      String? imageUrl;
      emit(const PostStateUpdatingPosts(
          isLoading: true, loadingText: 'Updating post'));
      try {
        if (!isInputValid(event.title)) {
          throw TitleCouldNotEmptyPostException();
        }
        if (!isInputValid(event.body)) {
          throw ContentCouldNotEmptyPostException();
        }
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

    // call then deleting post ()
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
