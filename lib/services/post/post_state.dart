import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/firestore/post.dart';

@immutable
abstract class PostState {
  final bool isLoading;
  final String? loadingText;
  const PostState({required this.isLoading, this.loadingText = 'Loading..'});
}

// when being initialise
class PostStateInitial extends PostState {
  const PostStateInitial({required bool isLoading})
      : super(isLoading: isLoading);
}

// News page----------------------------------------------------------------
// loading post
class PostStateLoadingPosts extends PostState {
  const PostStateLoadingPosts({
    required bool isLoading,
    String? loadingText,
  }) : super(isLoading: isLoading, loadingText: loadingText);
}

// after load required posts
class PostStatePostLoaded extends PostState {
  final Position currentPosition;
  final Iterable<Post> posts;
  const PostStatePostLoaded({
    required bool isLoading,
    required this.currentPosition,
    required this.posts,
  }) : super(isLoading: isLoading);
}

// emitted when the location have no post
class PostStateNoAvailablePost extends PostState {
  const PostStateNoAvailablePost({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted if there is an error
class PostStateLoadError extends PostState {
  final Exception? exception;
  const PostStateLoadError({required bool isLoading, required this.exception})
      : super(isLoading: isLoading);
}

// Bookmark page----------------------------------------------------------------
// emitted if bookmark post fetched successfully
class PostStateLoadedBookmarkedPosts extends PostState {
  final Iterable<Post> posts;
  const PostStateLoadedBookmarkedPosts({
    required bool isLoading,
    required this.posts,
  }) : super(isLoading: isLoading);
}

// emitted when there is no bookmark
class PostStateNoAvailableBookmarkPost extends PostState {
  const PostStateNoAvailableBookmarkPost({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when clearing all bookmarks
class PostStateClearingBookmarks extends PostState {
  const PostStateClearingBookmarks({
    required bool isLoading,
    String? loadingText,
  }) : super(isLoading: isLoading, loadingText: loadingText);
}

// emitted when clear all bookmarks successfully
class PostStateClearBookmarkSuccessfully extends PostState {
  const PostStateClearBookmarkSuccessfully({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when there is an error when clearing all bookmarks
class PostStateClearBookmarkError extends PostState {
  const PostStateClearBookmarkError({required bool isLoading})
      : super(isLoading: isLoading);
}

// Create post page------------------------------------------------------------
// emitted when creating post, initiate create post page
class PostStateCreatingPost extends PostState {
  final Position? position;
  final Exception? exception;
  const PostStateCreatingPost({
    required this.position,
    required bool isLoading,
    this.exception,
  }) : super(isLoading: isLoading);
}

// emitted when create post successfully
class PostStateCreatePostSuccessful extends PostState {
  const PostStateCreatePostSuccessful({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when creating a post
class PostStateSubmittingPost extends PostState {
  const PostStateSubmittingPost({required bool isLoading, String? loadingText})
      : super(isLoading: isLoading, loadingText: loadingText);
}

// emitted when loading post based on the text
class PostStateSearchLoading extends PostState {
  const PostStateSearchLoading({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when search result are ready
class PostStateSearchLoaded extends PostState {
  final Iterable<Post> filteredPosts;
  const PostStateSearchLoaded({
    required bool isLoading,
    required this.filteredPosts,
  }) : super(isLoading: isLoading);
}

// emitted when there is an error when searching
class PostStateSearchError extends PostState {
  const PostStateSearchError({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when loaded the posted posts
class PostStateLoadedPostedPost extends PostState {
  final Iterable<Post> posts;
  const PostStateLoadedPostedPost({
    required bool isLoading,
    required this.posts,
  }) : super(isLoading: isLoading);
}

// emitted when no posted post
class PostStateNoAvailablePostedPost extends PostState {
  const PostStateNoAvailablePostedPost({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when error when loading posted post
class PostStateLoadPostedPostsError extends PostState {
  const PostStateLoadPostedPostsError({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when updating posts
class PostStateUpdatingPosts extends PostState {
  const PostStateUpdatingPosts({required bool isLoading, String? loadingText})
      : super(isLoading: isLoading, loadingText: loadingText);
}

// emitted when error when updating posts
class PostStateUpdatePostError extends PostState {
  final Exception? exception;
  const PostStateUpdatePostError(
      {required bool isLoading, required this.exception})
      : super(isLoading: isLoading);
}

// emitted when update a post successfully
class PostStateUpdatePostSuccessfully extends PostState {
  const PostStateUpdatePostSuccessfully({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when there is an error when updating post reactions
class PostStateUpdateReactionsError extends PostState {
  const PostStateUpdateReactionsError({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when submitting report
class PostStateSubmittingReport extends PostState {
  const PostStateSubmittingReport({
    required bool isLoading,
    String? loadingText,
  }) : super(isLoading: isLoading, loadingText: loadingText);
}

// emitted when create report successfully
class PostStateCreateReportSuccessful extends PostState {
  const PostStateCreateReportSuccessful({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when error when creating report
class PostStateCreateReportError extends PostState {
  final Exception? exception;
  const PostStateCreateReportError({
    required bool isLoading,
    required this.exception,
  }) : super(isLoading: isLoading);
}

// emitted when error deleting post
class PostStateDeleteError extends PostState {
  const PostStateDeleteError({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when deleting post
class PostStateDeletingPost extends PostState {
  const PostStateDeletingPost({required bool isLoading, String? loadingText})
      : super(isLoading: isLoading, loadingText: loadingText);
}

// emitted when delete post successfully
class PostStateDeletePostSuccessful extends PostState {
  const PostStateDeletePostSuccessful({required bool isLoading})
      : super(isLoading: isLoading);
}
