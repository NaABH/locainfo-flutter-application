import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/pages/app/report_page.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';
import 'package:share_plus/share_plus.dart';

class MyPostBottomBar extends StatefulWidget {
  final Post post;
  final bool isBookmarked;
  const MyPostBottomBar({
    super.key,
    required this.post,
    required this.isBookmarked,
  });

  @override
  State<MyPostBottomBar> createState() => _MyPostBottomBarState();
}

class _MyPostBottomBarState extends State<MyPostBottomBar> {
  late final Post post = widget.post;
  late bool isBookmarked = widget.isBookmarked;
  late bool isLiked = widget.post.isLiked;
  late bool isDisliked = widget.post.isDisliked;
  late int numberOfLikes = widget.post.numberOfLikes;
  late int numberOfDislikes = widget.post.numberOfDislikes;

  void _removeLiked() {
    if (isLiked) {
      isLiked = !isLiked;
      numberOfLikes = isLiked ? numberOfLikes + 1 : numberOfLikes - 1;
      context
          .read<PostBloc>()
          .add(PostEventUpdatePostLike(post.documentId, UserAction.unlike));
    }
  }

  void _removeDisliked() {
    if (isDisliked) {
      isDisliked = !isDisliked;
      numberOfDislikes =
          isDisliked ? numberOfDislikes + 1 : numberOfDislikes - 1;
      context.read<PostBloc>().add(PostEventUpdatePostDislike(
          post.documentId, UserAction.removeDislike));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
      height: 50,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isLiked = !isLiked;
                numberOfLikes = isLiked ? numberOfLikes + 1 : numberOfLikes - 1;
                context.read<PostBloc>().add(isLiked
                    ? PostEventUpdatePostLike(post.documentId, UserAction.like)
                    : PostEventUpdatePostLike(
                        post.documentId, UserAction.unlike));

                // remove the disliked if it is enabled
                _removeDisliked();
              });
            },
            child: Row(
              children: [
                isLiked
                    ? const Icon(Icons.thumb_up)
                    : const Icon(Icons.thumb_up_off_alt_outlined),
                const SizedBox(width: 2),
                Text(numberOfLikes.toString()),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isDisliked = !isDisliked;
                numberOfDislikes =
                    isDisliked ? numberOfDislikes + 1 : numberOfDislikes - 1;

                context.read<PostBloc>().add(isDisliked
                    ? PostEventUpdatePostDislike(
                        post.documentId, UserAction.dislike)
                    : PostEventUpdatePostDislike(
                        post.documentId, UserAction.removeDislike));

                // remove like if enabled
                _removeLiked();
              });
            },
            child: Row(
              children: [
                isDisliked
                    ? const Icon(Icons.thumb_down)
                    : const Icon(Icons.thumb_down_outlined),
                const SizedBox(width: 2),
                Text(numberOfDislikes.toString()),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportPage(post: post),
                ),
              );
            },
            child: const Icon(Icons.report),
          ),
          GestureDetector(
            onTap: () async {
              await Share.share('${post.title}\n${post.text}');
            },
            child: const Icon(Icons.share),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isBookmarked = !isBookmarked;
                // update the database, add bookmark
                if (isBookmarked) {
                  context.read<PostBloc>().add(PostEventUpdateBookmarkList(
                      post.documentId, UserAction.bookmark));
                } else {
                  // update the database, remove bookmark
                  context.read<PostBloc>().add(PostEventUpdateBookmarkList(
                      post.documentId, UserAction.removeBookmark));
                }
              });
            },
            child: isBookmarked
                ? const Icon(Icons.bookmark_added)
                : const Icon(Icons.bookmark_add_outlined),
          ),
        ],
      ),
    );
  }
}
