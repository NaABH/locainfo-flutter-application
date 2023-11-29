import 'package:flutter/foundation.dart';
import 'package:locainfo/services/firestore/post.dart';

@immutable
abstract class MainState {
  const MainState();
}

class MainStateHome extends MainState {
  const MainStateHome();
}

class MainStateNews extends MainState {
  const MainStateNews();
}

class MainStateBookmark extends MainState {
  const MainStateBookmark();
}

class MainStateProfile extends MainState {
  const MainStateProfile();
}

class MainStateViewPostedPosts extends MainState {
  const MainStateViewPostedPosts();
}

class MainStateViewPostDetail extends MainState {
  final Post post;
  final List<String> bookmarkedPostIds;
  const MainStateViewPostDetail(this.post, this.bookmarkedPostIds);
}
