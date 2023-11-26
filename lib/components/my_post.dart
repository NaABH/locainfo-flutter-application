import 'package:flutter/material.dart';
import 'package:locainfo/components/my_bookmark_button.dart';
import 'package:locainfo/components/my_likedislike_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/services/firestore/post.dart';

class MyPost extends StatelessWidget {
  final Post post;

  const MyPost({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.person),
          const SizedBox(width: 8),
          Text(
            post.ownerUserName,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationAndDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        '${post.locationName}, ${post.timeAgo}',
        style: const TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
          color: Colors.blueGrey,
        ),
        maxLines: 1,
        softWrap: true,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildPostTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        post.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        maxLines: 2,
        softWrap: true,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildPostContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        post.text,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
        textAlign: TextAlign.justify,
        maxLines: 4,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 10, top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          onPressed: () {},
          icon: const Icon(Icons.share, size: 20),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: MyBookmarkButton(
            postId: post.documentId,
            isBookmarked: true,
          ),
        ),
      ],
    );
  }
}
