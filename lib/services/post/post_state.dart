import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/firestore/current_user.dart';
import 'package:locainfo/services/firestore/post.dart';

@immutable
abstract class PostState {
  final bool isLoading;
  final String? loadingText;
  const PostState({required this.isLoading, this.loadingText = 'Loading..'});
}

class PostStateInitial extends PostState {
  const PostStateInitial({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateLoadingPosts extends PostState {
  const PostStateLoadingPosts({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateLoaded extends PostState {
  final Position currentPosition;
  final Iterable<Post> posts;
  final List<String> bookmarkedPosts;
  const PostStateLoaded({
    required bool isLoading,
    required this.currentPosition,
    required this.posts,
    required this.bookmarkedPosts,
  }) : super(isLoading: isLoading);
}

class PostStateLoadedBookmarkedPosts extends PostState {
  final Iterable<Post> posts;
  final List<String> bookmarkedPosts;
  const PostStateLoadedBookmarkedPosts({
    required bool isLoading,
    required this.posts,
    required this.bookmarkedPosts,
  }) : super(isLoading: isLoading);
}

class PostStateLoadedPostedPost extends PostState {
  final Iterable<Post> posts;
  final List<String> bookmarkedPosts;
  const PostStateLoadedPostedPost({
    required bool isLoading,
    required this.posts,
    required this.bookmarkedPosts,
  }) : super(isLoading: isLoading);
}

class PostStateNoAvailablePost extends PostState {
  const PostStateNoAvailablePost({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateNoAvailablePostedPost extends PostState {
  const PostStateNoAvailablePostedPost({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateNoAvailableBookmarkPost extends PostState {
  const PostStateNoAvailableBookmarkPost({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateLoadError extends PostState {
  const PostStateLoadError({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateDeleteError extends PostState {
  const PostStateDeleteError({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateLoadPostedPostsError extends PostState {
  const PostStateLoadPostedPostsError({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateLoadBookmarksError extends PostState {
  const PostStateLoadBookmarksError({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateUpdatePostError extends PostState {
  const PostStateUpdatePostError({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateCreatingPost extends PostState {
  final Position? position;
  final Exception? exception;
  const PostStateCreatingPost({
    required this.position,
    required bool isLoading,
    this.exception,
  }) : super(isLoading: isLoading);
}

class PostStateSubmittingPost extends PostState {
  const PostStateSubmittingPost({required bool isLoading, String? loadingText})
      : super(isLoading: isLoading, loadingText: loadingText);
}

class PostStateDeletingPost extends PostState {
  const PostStateDeletingPost({required bool isLoading, String? loadingText})
      : super(isLoading: isLoading, loadingText: loadingText);
}

class PostStateUpdatingPosts extends PostState {
  const PostStateUpdatingPosts({required bool isLoading, String? loadingText})
      : super(isLoading: isLoading, loadingText: loadingText);
}

class PostStateSubmittingReport extends PostState {
  const PostStateSubmittingReport(
      {required bool isLoading, String? loadingText})
      : super(isLoading: isLoading, loadingText: loadingText);
}

class PostStateCreatePostSuccessful extends PostState {
  const PostStateCreatePostSuccessful({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateDeletePostSuccessful extends PostState {
  const PostStateDeletePostSuccessful({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateCreateReportSuccessful extends PostState {
  const PostStateCreateReportSuccessful({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateCreateReportError extends PostState {
  const PostStateCreateReportError({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateUpdatePostSuccessfully extends PostState {
  const PostStateUpdatePostSuccessfully({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateLoadingCurrentLocation extends PostState {
  const PostStateLoadingCurrentLocation({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateSearchInitialise extends PostState {
  const PostStateSearchInitialise({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateSearchLoading extends PostState {
  const PostStateSearchLoading({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateSearchLoaded extends PostState {
  final Iterable<Post> filteredPosts;
  const PostStateSearchLoaded({
    required bool isLoading,
    required this.filteredPosts,
  }) : super(isLoading: isLoading);
}

class PostStateSearchError extends PostState {
  const PostStateSearchError({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateClearBookmarkSuccessfully extends PostState {
  const PostStateClearBookmarkSuccessfully({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateClearBookmarkError extends PostState {
  const PostStateClearBookmarkError({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateProfileInitialised extends PostState {
  final CurrentUser user;
  const PostStateProfileInitialised(
      {required bool isLoading, required this.user})
      : super(isLoading: isLoading);
}

class PostStateProfileInitialiseFail extends PostState {
  const PostStateProfileInitialiseFail({required bool isLoading})
      : super(isLoading: isLoading);
}
