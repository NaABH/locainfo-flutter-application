import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';

// custom like button using like_button package for animation
// used for post
class MyLikeDislikeButton extends StatefulWidget {
  final Post post;
  final Function(Post) onUpdatePostState;

  const MyLikeDislikeButton({
    Key? key,
    required this.post,
    required this.onUpdatePostState,
  }) : super(key: key);

  @override
  State<MyLikeDislikeButton> createState() => _MyLikeDislikeButtonState();
}

class _MyLikeDislikeButtonState extends State<MyLikeDislikeButton> {
  late String postId;
  late bool isLiked;
  late int numberOfLikes;
  late bool isDisliked;
  late int numberOfDislikes;

  @override
  void initState() {
    postId = widget.post.documentId;
    isLiked = widget.post.isLiked;
    numberOfLikes = widget.post.numberOfLikes;
    isDisliked = widget.post.isDisliked;
    numberOfDislikes = widget.post.numberOfDislikes;
    super.initState();
  }

  Future<bool?> onLikeButtonTapped(bool isLiked) async {
    setState(() {
      this.isLiked = !this.isLiked;
      numberOfLikes = this.isLiked ? numberOfLikes + 1 : numberOfLikes - 1;
      context.read<PostBloc>().add(this.isLiked
          ? PostEventUpdatePostReactions(postId, UserAction.like)
          : PostEventUpdatePostReactions(postId, UserAction.unlike));

      // remove the disliked if it is enabled
      _removeDisliked();
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
        isLiked: this.isLiked,
        isDisliked: isDisliked,
        numberOfLikes: numberOfLikes,
        numberOfDislikes: numberOfDislikes,
        isBookmarked: widget.post.isBookmarked,
      ),
    );

    return this.isLiked;
  }

  void _removeDisliked() {
    if (isDisliked) {
      isDisliked = !isDisliked;
      numberOfDislikes =
          isDisliked ? numberOfDislikes + 1 : numberOfDislikes - 1;
      context
          .read<PostBloc>()
          .add(PostEventUpdatePostReactions(postId, UserAction.removeDislike));
    }
  }

  Future<bool?> onDislikeButtonTapped(bool isDisliked) async {
    setState(() {
      this.isDisliked = !this.isDisliked;
      numberOfDislikes =
          this.isDisliked ? numberOfDislikes + 1 : numberOfDislikes - 1;

      context.read<PostBloc>().add(this.isDisliked
          ? PostEventUpdatePostReactions(postId, UserAction.dislike)
          : PostEventUpdatePostReactions(postId, UserAction.removeDislike));

      // remove like if enabled
      _removeLiked();
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
        isLiked: isLiked,
        isDisliked: this.isDisliked,
        numberOfLikes: numberOfLikes,
        numberOfDislikes: numberOfDislikes,
        isBookmarked: widget.post.isBookmarked,
      ),
    );

    return this.isDisliked;
  }

  void _removeLiked() {
    if (isLiked) {
      isLiked = !isLiked;
      numberOfLikes = isLiked ? numberOfLikes + 1 : numberOfLikes - 1;
      context
          .read<PostBloc>()
          .add(PostEventUpdatePostReactions(postId, UserAction.unlike));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LikeButton(
          onTap: onLikeButtonTapped,
          size: 20,
          likeBuilder: (bool isLiked) {
            return Icon(
              this.isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt_outlined,
              color: this.isLiked ? AppColors.red : Colors.black,
              size: 20,
            );
          },
          likeCount: numberOfLikes,
          countBuilder: (int? numberOfLikes, bool isLiked, String? text) {
            Widget result;
            if (numberOfLikes == 0 || numberOfLikes == null) {
              result = Text(
                "Useful",
                style: CustomFontStyles.likeDislikeButtonLabel,
              );
            } else {
              result = Text(
                text ?? '',
                style: CustomFontStyles.likeDislikeButtonLabel,
              );
            }
            return result;
          },
        ),
        const SizedBox(width: 12),
        LikeButton(
          onTap: onDislikeButtonTapped,
          size: 20,
          likeBuilder: (bool isDisliked) {
            return Icon(
              this.isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
              color: this.isDisliked ? AppColors.red : Colors.black,
              size: 20,
            );
          },
          likeCount: numberOfDislikes,
          countBuilder: (int? numberOfDislikes, bool isDisliked, String? text) {
            Widget result;
            if (numberOfDislikes == 0 || numberOfDislikes == null) {
              result = Text(
                "Not Useful",
                style: CustomFontStyles.likeDislikeButtonLabel,
              );
            } else {
              result = Text(
                text ?? '',
                style: CustomFontStyles.likeDislikeButtonLabel,
              );
            }
            return result;
          },
        ),
      ],
    );
  }
}
