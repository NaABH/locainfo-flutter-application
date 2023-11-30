import 'dart:io';

import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/services/firestore/post.dart';

abstract class PostEvent {
  const PostEvent();
}

class PostEventLoadNearbyPosts extends PostEvent {
  const PostEventLoadNearbyPosts();
}

class PostEventLoadPostedPosts extends PostEvent {
  const PostEventLoadPostedPosts();
}

class PostEventLoadBookmarkedPosts extends PostEvent {
  const PostEventLoadBookmarkedPosts();
}

class PostEventCreatePost extends PostEvent {
  final String title;
  final String body;
  final File? image;
  final String? category;
  const PostEventCreatePost(this.title, this.body, this.image, this.category);
}

class PostEventCreateReport extends PostEvent {
  final Post post;
  final String reason;
  const PostEventCreateReport(this.post, this.reason);
}

class PostEventUpdatePost extends PostEvent {
  final String postId;
  final String title;
  final String body;
  final File? image;
  final bool imageUpdated;
  const PostEventUpdatePost(
      this.postId, this.title, this.body, this.image, this.imageUpdated);
}

class PostEventCreatingPost extends PostEvent {
  const PostEventCreatingPost();
}

class PostEventUpdatePostLike extends PostEvent {
  final String documentId;
  final UserAction action;
  const PostEventUpdatePostLike(this.documentId, this.action);
}

class PostEventUpdatePostDislike extends PostEvent {
  final String documentId;
  final UserAction action;
  const PostEventUpdatePostDislike(this.documentId, this.action);
}

class PostEventUpdateBookmarkList extends PostEvent {
  final String documentId;
  final UserAction action;
  const PostEventUpdateBookmarkList(this.documentId, this.action);
}

class PostEventSearchPostTextChanged extends PostEvent {
  final String? searchText;
  const PostEventSearchPostTextChanged(this.searchText);
}

class PostEventClearAllBookmark extends PostEvent {
  const PostEventClearAllBookmark();
}

class PostEventDeletePost extends PostEvent {
  final String documentId;
  const PostEventDeletePost(this.documentId);
}

class PostEventInitialiseProfile extends PostEvent {
  const PostEventInitialiseProfile();
}
