abstract class PostEvent {
  const PostEvent();
}

class PostEventLoadNearbyPosts extends PostEvent {
  final int page;
  const PostEventLoadNearbyPosts({this.page = 1});
}

class PostEventLoadPostedPosts extends PostEvent {
  const PostEventLoadPostedPosts();
}

class PostEventCreatePost extends PostEvent {
  final String title;
  final String body;
  final String category;
  const PostEventCreatePost(this.title, this.body, this.category);
}

class PostEventCreatePostInitialise extends PostEvent {
  const PostEventCreatePostInitialise();
}
