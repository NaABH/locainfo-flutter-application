import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:locainfo/constants/custom_datatype.dart';

abstract class PostEvent {
  const PostEvent();
}

// call in home page
class PostEventLoadNearbyPostsHome extends PostEvent {
  final Position position;
  const PostEventLoadNearbyPostsHome(this.position);
}

// call in news page
class PostEventLoadNearbyPosts extends PostEvent {
  const PostEventLoadNearbyPosts();
}

// call in bookmark page
class PostEventLoadBookmarkedPosts extends PostEvent {
  const PostEventLoadBookmarkedPosts();
}

// call in bookmark page
class PostEventClearAllBookmark extends PostEvent {
  const PostEventClearAllBookmark();
}

// call in create post page
class PostEventInitialiseCreatePost extends PostEvent {
  const PostEventInitialiseCreatePost();
}

// call in create post page
class PostEventSavePreviousState extends PostEvent {
  const PostEventSavePreviousState();
}

// call in create post page
class PostEventBackToLastState extends PostEvent {
  const PostEventBackToLastState();
}

// call in create post page
class PostEventCreatePost extends PostEvent {
  final String title;
  final String body;
  final File? image;
  final String? category;
  final String? contact;
  const PostEventCreatePost(
      this.title, this.body, this.image, this.category, this.contact);
}

// call in search page when the text changed
class PostEventSearchPostTextChanged extends PostEvent {
  final String? searchText;
  const PostEventSearchPostTextChanged(this.searchText);
}

// call in posted post page
class PostEventLoadPostedPosts extends PostEvent {
  const PostEventLoadPostedPosts();
}

// call in update post page
class PostEventUpdatePostContent extends PostEvent {
  final String postId;
  final String title;
  final String body;
  final File? image;
  final bool imageUpdated;
  final String? newContact;
  const PostEventUpdatePostContent(this.postId, this.title, this.body,
      this.image, this.imageUpdated, this.newContact);
}

// call when want update post reactions
class PostEventUpdatePostReactions extends PostEvent {
  final String documentId;
  final UserAction action;
  const PostEventUpdatePostReactions(this.documentId, this.action);
}

// call when creating a report (report page)
class PostEventCreateReport extends PostEvent {
  final String postId;
  final String reason;
  const PostEventCreateReport(this.postId, this.reason);
}

// call when delete a post (my post)
class PostEventDeletePost extends PostEvent {
  final String documentId;
  const PostEventDeletePost(this.documentId);
}
