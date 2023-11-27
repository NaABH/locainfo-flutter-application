import 'package:flutter/material.dart';
import 'package:locainfo/components/my_post.dart';
import 'package:locainfo/services/firestore/post.dart';

// call when user press the post
typedef PostCallBack = void Function(Post post);

// generate a list view of post
class MyPostList extends StatelessWidget {
  final Iterable<Post> posts;
  final List<String> bookmarkedPosts;
  final PostCallBack onTap;

  const MyPostList({
    Key? key,
    required this.posts,
    required this.onTap,
    required this.bookmarkedPosts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index); // get current note
        return MyPost(
          post: post,
          isBookMarked: bookmarkedPosts.contains(post.documentId),
        );
      },
    );
  }
}
