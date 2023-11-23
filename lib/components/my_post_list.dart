import 'package:flutter/material.dart';
import 'package:locainfo/components/my_post.dart';
import 'package:locainfo/services/firestore/post.dart';

// call when user press yes
typedef PostCallBack = void Function(Post note);

class MyPostList extends StatelessWidget {
  final Iterable<Post> posts;
  final PostCallBack onTap;

  const MyPostList({
    Key? key,
    required this.posts,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index); // get current note
        return MyPost(
            author: post.ownerUserName,
            locationName: post.locationName,
            date: post.timeAgo,
            title: post.title,
            content: post.text);
      },
    );
  }
}
