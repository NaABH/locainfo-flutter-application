import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
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
  final Iterable<Post> posts;
  const PostStateLoaded({
    required bool isLoading,
    required this.posts,
  }) : super(isLoading: isLoading);
}

class PostStateNoAvailablePost extends PostState {
  const PostStateNoAvailablePost({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateLoadError extends PostState {
  const PostStateLoadError({required bool isLoading})
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

class PostStateCreatePostSuccessful extends PostState {
  const PostStateCreatePostSuccessful({required bool isLoading})
      : super(isLoading: isLoading);
}

class PostStateLoadingCurrentLocation extends PostState {
  const PostStateLoadingCurrentLocation({required bool isLoading})
      : super(isLoading: isLoading);
}
