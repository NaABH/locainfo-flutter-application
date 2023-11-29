import 'package:flutter/material.dart';
import 'package:locainfo/components/my_post.dart';
import 'package:locainfo/constants/actions.dart';
import 'package:locainfo/services/firestore/post.dart';

// call when user press yes
typedef PostCallBack = void Function(Post note);

class MyHomePostList extends StatelessWidget {
  final Iterable<Post> posts;
  final PostCallBack onTap;

  const MyHomePostList({
    Key? key,
    required this.posts,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index); // get current note
        return MyPost(
          onTap: onTap,
          post: post,
          isBookMarked: false,
          patternType: PostPatternType.newsPost,
          currentPosition: null,
        );
      },
    );
  }
}
