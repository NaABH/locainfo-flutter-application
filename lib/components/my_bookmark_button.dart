import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';

// custom bookmark button that use the like_button package for animation
class MyBookmarkButton extends StatefulWidget {
  final Post post;
  final Function(Post)
      onUpdatePostState; // call back when clicked to update the post state

  const MyBookmarkButton({
    Key? key,
    required this.post,
    required this.onUpdatePostState,
  }) : super(key: key);

  @override
  State<MyBookmarkButton> createState() => _MyBookmarkButtonState();
}

class _MyBookmarkButtonState extends State<MyBookmarkButton> {
  late String postId;
  late bool isBookmarked;

  @override
  void initState() {
    postId = widget.post.documentId;
    isBookmarked = widget.post.isBookmarked;
    super.initState();
  }

  Future<bool?> onBookmarkButtonTapped(bool isBookmarked) async {
    setState(() {
      this.isBookmarked = !this.isBookmarked;
      final postBloc = context.read<PostBloc>();

      if (this.isBookmarked) {
        postBloc.add(PostEventUpdatePostReactions(postId, UserAction.bookmark));
      } else {
        postBloc.add(
            PostEventUpdatePostReactions(postId, UserAction.removeBookmark));
      }
    });

    widget.onUpdatePostState(
      Post(
        documentId: postId,
        ownerUserId: widget.post.ownerUserId,
        ownerUserName: widget.post.ownerUserName,
        ownerProfilePicUrl: widget.post.ownerProfilePicUrl,
        title: widget.post.title,
        content: widget.post.content,
        imageUrl: widget.post.imageUrl,
        contact: widget.post.contact,
        category: widget.post.category,
        postedDate: widget.post.postedDate,
        latitude: widget.post.latitude,
        longitude: widget.post.longitude,
        distance: widget.post.distance,
        locationName: widget.post.locationName,
        isLiked: widget.post.isLiked,
        isDisliked: widget.post.isDisliked,
        numberOfLikes: widget.post.numberOfLikes,
        numberOfDislikes: widget.post.numberOfDislikes,
        isBookmarked: this.isBookmarked,
      ),
    );

    return this.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: 22,
      circleColor: const CircleColor(
        start: Color(0xff00ddff),
        end: AppColors.darkerBlue,
      ),
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
