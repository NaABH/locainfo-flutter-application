import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/cloud_storage/cloudstorage_provider.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/location/location_provider.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_exceptions.dart';
import 'package:locainfo/services/post/post_state.dart';
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
  ) : super(const PostStateInitial(isLoading: true)) {
    on<PostEventLoadNearbyPosts>((event, emit) async {
      emit(const PostStateLoadingPosts(isLoading: false));
      try {
        final position = await _locationProvider.getCurrentLocation();
        final posts = await _databaseProvider.getNearbyPosts(
          position: position,
          currentUserId: _authProvider.currentUser!.id,
        );
        if (posts.isEmpty) {
          emit(const PostStateNoAvailablePost(isLoading: false));
        } else {
          final bookmarkedPost = await _databaseProvider
              .getBookmarkedPostIds(_authProvider.currentUser!.id);
          emit(PostStateLoaded(
              isLoading: false,
              posts: posts,
              bookmarkedPosts: bookmarkedPost,
              currentPosition: position));
        }
      } on Exception catch (e) {
        print(e.toString());
        emit(const PostStateLoadError(isLoading: false));
      }
    });

    on<PostEventClearAllBookmark>((event, emit) async {
      try {
        final userId = _authProvider.currentUser!.id;
        await _databaseProvider.clearBookmarkList(currentUserId: userId);
        emit(const PostStateClearBookmarkSuccessfully(isLoading: false));
      } on Exception catch (_) {
        emit(const PostStateClearBookmarkError(isLoading: false));
      }
    });

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
          return;
        }
      } on Exception catch (_) {
        emit(const PostStateSearchError(isLoading: false));
      }
    });

    on<PostEventLoadPostedPosts>((event, emit) async {
      emit(const PostStateLoadingPosts(isLoading: false));
      try {
        final userId = _authProvider.currentUser!.id;
        final posts =
            await _databaseProvider.getPostedPosts(currentUserId: userId);
        if (posts.isNotEmpty) {
          final bookmarkedPost = await _databaseProvider
              .getBookmarkedPostIds(_authProvider.currentUser!.id);
          emit(PostStateLoadedPostedPost(
              posts: posts, isLoading: false, bookmarkedPosts: bookmarkedPost));
        } else {
          emit(const PostStateNoAvailablePostedPost(isLoading: false));
        }
      } on Exception catch (e) {
        emit(const PostStateLoadPostedPostsError(isLoading: false));
      }
    });

    on<PostEventUpdatePost>((event, emit) async {
      String? imageUrl;
      emit(const PostStateUpdatingPosts(
          isLoading: false, loadingText: 'Updating'));
      try {
        if (event.title.trim().isEmpty ||
            RegExp(r'^[0-9\W_]').hasMatch(event.title)) {
          throw TitleCouldNotEmptyPostException();
        }
        if (event.body.trim().isEmpty ||
            RegExp(r'^[0-9\W_]').hasMatch(event.body)) {
          throw ContentCouldNotEmptyPostException();
        }

        if (event.imageUpdated) {
          if (event.image != null) {
            imageUrl = await _cloudStorageProvider
                .uploadPostImageToFirebaseStorage(event.image!);
          }

          await _databaseProvider.updatePostImage(
              documentId: event.postId, imageUrl: imageUrl);
        }

        await _databaseProvider.updatePostTitleContent(
          documentId: event.postId,
          title: event.title,
          text: event.body,
        );
        emit(const PostStateUpdatePostSuccessfully(isLoading: false));
      } on Exception catch (e) {
        emit(const PostStateUpdatePostError(isLoading: false));
      }
    });

    on<PostEventLoadBookmarkedPosts>((event, emit) async {
      emit(const PostStateLoadingPosts(isLoading: false));
      try {
        final userId = _authProvider.currentUser!.id;
        final postIds = await _databaseProvider.getBookmarkedPostIds(userId);
        final posts = await _databaseProvider.getBookmarkedPosts(userId);
        if (posts.isNotEmpty) {
          emit(PostStateLoadedBookmarkedPosts(
              posts: posts, isLoading: false, bookmarkedPosts: postIds));
        } else {
          emit(const PostStateNoAvailableBookmarkPost(isLoading: false));
        }
      } on Exception catch (e) {
        emit(const PostStateLoadBookmarksError(isLoading: false));
      }
    });

    on<PostEventCreatePost>((event, emit) async {
      String? imageUrl;
      late Position position;
      emit(const PostStateSubmittingPost(
          isLoading: true, loadingText: 'Submitting...'));
      try {
        position = await _locationProvider
            .getCurrentLocation(); // CouldNotGetLocationException
        if (event.title.trim().isEmpty ||
            RegExp(r'^[0-9\W_]').hasMatch(event.title)) {
          throw TitleCouldNotEmptyPostException();
        }
        if (event.body.trim().isEmpty ||
            RegExp(r'^[0-9\W_]').hasMatch(event.body)) {
          throw ContentCouldNotEmptyPostException();
        }
        if (event.category == null ||
            !postCategories.containsKey(event.category)) {
          throw CategoryInvalidPostException();
        }
        Future.delayed(const Duration(seconds: 1), () async {
          //upload picture
          if (event.image != null) {
            imageUrl = await _cloudStorageProvider
                .uploadPostImageToFirebaseStorage(event.image!);
          }
          String locationName =
              await getLocationName(position.latitude, position.longitude);
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
          emit(const PostStateCreatePostSuccessful(isLoading: false));
        });
      } on Exception catch (e) {
        emit(PostStateCreatingPost(
            isLoading: false, exception: e, position: position));
      }
    });

    on<PostEventCreateReport>((event, emit) async {
      emit(const PostStateSubmittingReport(
          isLoading: true, loadingText: 'Submitting...'));
      if (event.reason.trim().isEmpty ||
          RegExp(r'^[0-9\W_]').hasMatch(event.reason)) {
        throw ReasonCouldNotEmptyPostException();
      }
      try {
        Timestamp postedTimestamp = Timestamp.fromDate(DateTime.now());
        await _databaseProvider.createNewReport(
          reporterId: _authProvider.currentUser!.id,
          postId: event.post.documentId,
          reason: event.reason,
          reportDate: postedTimestamp,
        );
        emit(const PostStateCreateReportSuccessful(isLoading: false));
      } on Exception catch (e) {
        emit(const PostStateCreateReportError(isLoading: false));
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

    on<PostEventDeletePost>((event, emit) async {
      emit(const PostStateDeletingPost(
          isLoading: false, loadingText: 'Deleting'));
      try {
        await _databaseProvider.deletePost(documentId: event.documentId);
        emit(const PostStateDeletePostSuccessful(isLoading: false));
      } on Exception catch (e) {
        emit(const PostStateDeleteError(isLoading: false));
      }
    });

    on<PostEventInitialiseProfile>((event, emit) async {
      try {
        final user = await _databaseProvider.getUser(
            currentUserId: _authProvider.currentUser!.id);
        print('sdhsjdjasdha');
        emit(PostStateProfileInitialised(isLoading: false, user: user));
      } on Exception catch (_) {
        print('fail');
        emit(const PostStateProfileInitialiseFail(isLoading: false));
      }
    });
  }
}
