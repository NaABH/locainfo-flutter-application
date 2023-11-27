import 'package:flutter/material.dart';
import 'package:locainfo/components/my_bookmark_button.dart';
import 'package:locainfo/components/my_likedislike_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:share_plus/share_plus.dart';

class MyPost extends StatelessWidget {
  final Post post;
  final bool isBookMarked;

  const MyPost({
    Key? key,
    required this.post,
    required this.isBookMarked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.grey2,
        border: Border.all(color: AppColors.grey3),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          _buildLocationAndDate(),
          _buildPostTitle(),
          _buildPostContent(),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.person,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            post.ownerUserName,
            style: CustomFontStyles.postUsernameLabel,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationAndDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '${post.locationName}, ${post.timeAgo}',
        style: CustomFontStyles.postLocationDateLabel,
        maxLines: 1,
        softWrap: true,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildPostTitle() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 5),
      child: Text(
        post.title,
        style: CustomFontStyles.postTitleLabel,
        maxLines: 2,
        softWrap: true,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildPostContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Text(
        post.text,
        style: CustomFontStyles.postContentText,
        textAlign: TextAlign.justify,
        maxLines: 3,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLikeDislikeButton(),
          _buildShareAndBookmark(),
        ],
      ),
    );
  }

  Widget _buildLikeDislikeButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyLikeDislikeButton(
          postId: post.documentId,
          isLiked: post.isLiked,
          numberOfLikes: post.numberOfLikes,
          isDisliked: post.isDisliked,
          numberOfDislikes: post.numberOfDislikes,
        ),
      ],
    );
  }

  Widget _buildShareAndBookmark() {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            await Share.share('${post.title}\n${post.text}');
          },
          splashRadius: 1,
          icon: const Icon(Icons.share, size: 20),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: MyBookmarkButton(
            postId: post.documentId,
            isBookmarked: isBookMarked,
          ),
        ),
      ],
    );
  }
}
