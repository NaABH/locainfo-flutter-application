import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';

// custom book mark button using like_button package
class MyBookmarkButton extends StatefulWidget {
  final String postId;
  final bool isBookmarked;
  const MyBookmarkButton(
      {super.key, required this.postId, required this.isBookmarked});

  @override
  State<MyBookmarkButton> createState() => _MyBookmarkButtonState();
}

class _MyBookmarkButtonState extends State<MyBookmarkButton> {
  late String postId;
  late bool isBookmarked;

  @override
  void initState() {
    postId = widget.postId;
    isBookmarked = widget.isBookmarked;
    super.initState();
  }

  Future<bool?> onBookmarkButtonTapped(bool isBookmarked) async {
    setState(() {
      this.isBookmarked = !this.isBookmarked;

      // update the database, add bookmark
      if (this.isBookmarked) {
        context
            .read<PostBloc>()
            .add(PostEventUpdateBookmarkList(postId, UserAction.bookmark));
      } else {
        // update the database, remove bookmark
        context.read<PostBloc>().add(
            PostEventUpdateBookmarkList(postId, UserAction.removeBookmark));
      }
    });
    return this.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: 22,
      circleColor: const CircleColor(
          start: Color(0xff00ddff), end: AppColors.darkerBlue),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: AppColors.darkerBlue,
        dotSecondaryColor: AppColors.lighterBlue,
      ),
      likeBuilder: (bool isBookmarked) {
        return Icon(
          this.isBookmarked
              ? Icons.bookmark_added
              : Icons.bookmark_add_outlined,
          color: this.isBookmarked ? AppColors.darkerBlue : null,
          size: 20,
        );
      },
      onTap: onBookmarkButtonTapped,
    );
  }
}
