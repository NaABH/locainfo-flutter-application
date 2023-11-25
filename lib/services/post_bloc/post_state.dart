import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/firestore/post.dart';

abstract class PostState {
  const PostState();
}

class PostStateInitial extends PostState {
  const PostStateInitial();
}

class PostStateLoadingPosts extends PostState {
  const PostStateLoadingPosts();
}

class PostStateLoaded extends PostState {
  final Iterable<Post> posts;
  const PostStateLoaded(this.posts);
}

class PostStateNoAvailablePost extends PostState {
  const PostStateNoAvailablePost();
}

class PostStateLoadError extends PostState {
  final String message;
  const PostStateLoadError(this.message);
}

class PostStateCreatingPost extends PostState {
  const PostStateCreatingPost();
}

class PostStateCreatePostSuccessful extends PostState {
  const PostStateCreatePostSuccessful();
}

class PostStateCreatePostFail extends PostState {
  final Exception? exception;
  const PostStateCreatePostFail(this.exception);
}

class PostStateWantCreatePost extends PostState {
  final Position position;
  const PostStateWantCreatePost(this.position);
}

class PostStateLoadingCurrentLocation extends PostState {
  const PostStateLoadingCurrentLocation();
}
