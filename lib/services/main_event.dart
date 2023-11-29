import 'package:flutter/foundation.dart';
import 'package:locainfo/services/firestore/post.dart';

@immutable
abstract class MainEvent {
  const MainEvent();
}

class MainEventInitialise extends MainEvent {
  const MainEventInitialise();
}

class MainEventNavigationChanged extends MainEvent {
  final int index;
  const MainEventNavigationChanged({required this.index});
}

class MainEventViewPostedPosts extends MainEvent {
  const MainEventViewPostedPosts();
}

class MainEventViewPostDetail extends MainEvent {
  final Post post;
  final List<String> bookmarkedPostId;
  const MainEventViewPostDetail(this.post, this.bookmarkedPostId);
}
