import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:locainfo/constants/actions.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';

// custom like button using like_button package for animation
class MyLikeDislikeButton extends StatefulWidget {
  final String postId;
  final bool isLiked;
  final int numberOfLikes;
  final bool isDisliked;
  final int numberOfDislikes;

  const MyLikeDislikeButton({
    Key? key,
    required this.postId,
    required this.isLiked,
    required this.numberOfLikes,
    required this.isDisliked,
    required this.numberOfDislikes,
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
    postId = widget.postId;
    isLiked = widget.isLiked;
    numberOfLikes = widget.numberOfLikes;
    isDisliked = widget.isDisliked;
    numberOfDislikes = widget.numberOfDislikes;
    super.initState();
  }

  Future<bool?> onLikeButtonTapped(bool isLiked) async {
    setState(() {
      this.isLiked = !this.isLiked;
      numberOfLikes = this.isLiked ? numberOfLikes + 1 : numberOfLikes - 1;
      context.read<PostBloc>().add(this.isLiked
          ? PostEventUpdatePostLike(postId, UserAction.like)
          : PostEventUpdatePostLike(postId, UserAction.unlike));

      // remove the disliked if it is enabled
      _removeDisliked();
    });
    return this.isLiked;
  }

  void _removeDisliked() {
    if (isDisliked) {
      isDisliked = !isDisliked;
      numberOfDislikes =
          isDisliked ? numberOfDislikes + 1 : numberOfDislikes - 1;
      context
          .read<PostBloc>()
          .add(PostEventUpdatePostDislike(postId, UserAction.removeDislike));
    }
  }

  Future<bool?> onDislikeButtonTapped(bool isDisliked) async {
    setState(() {
      this.isDisliked = !this.isDisliked;
      numberOfDislikes =
          this.isDisliked ? numberOfDislikes + 1 : numberOfDislikes - 1;

      context.read<PostBloc>().add(this.isDisliked
          ? PostEventUpdatePostDislike(postId, UserAction.dislike)
          : PostEventUpdatePostDislike(postId, UserAction.removeDislike));

      // remove like if enabled
      _removeLiked();
    });
    return this.isDisliked;
  }

  void _removeLiked() {
    if (isLiked) {
      isLiked = !isLiked;
      numberOfLikes = isLiked ? numberOfLikes + 1 : numberOfLikes - 1;
      context
          .read<PostBloc>()
          .add(PostEventUpdatePostLike(postId, UserAction.unlike));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LikeButton(
          onTap: onLikeButtonTapped,
          size: 22,
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
        const SizedBox(width: 10),
        LikeButton(
          onTap: onDislikeButtonTapped,
          size: 22,
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
