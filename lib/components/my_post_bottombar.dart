import 'package:flutter/material.dart';
import 'package:locainfo/services/firestore/post.dart';

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
  late final bool isBookmarked = widget.isBookmarked;
  late final bool isLiked = widget.post.isLiked;
  late final bool isDisliked = widget.post.isDisliked;
  late final int numberOfLikes = widget.post.numberOfLikes;
  late final int numberOfDislikes = widget.post.numberOfDislikes;

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
            onTap: () {},
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
            onTap: () {},
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
            onTap: () {},
            child: const Icon(Icons.report),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.share),
          ),
          GestureDetector(
            onTap: () {},
            child: isBookmarked
                ? const Icon(Icons.bookmark_added)
                : const Icon(Icons.bookmark_add_outlined),
          ),
        ],
      ),
    );
  }
}
