import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:locainfo/components/my_bookmark_button.dart';
import 'package:locainfo/components/my_home_post_list.dart';
import 'package:locainfo/components/my_likedislike_button.dart';
import 'package:locainfo/constants/actions.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:share_plus/share_plus.dart';

class MyPost extends StatelessWidget {
  final Post post;
  final bool isBookMarked;
  final PostCallBack onTap;
  final PostPatternType patternType;

  const MyPost({
    Key? key,
    required this.post,
    required this.isBookMarked,
    required this.onTap,
    required this.patternType,
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
          GestureDetector(
              onTap: () {
                onTap(post);
              },
              child: _buildPostTitle()),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onTap(post);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      patternType != PostPatternType.postedPost
                          ? _buildUserInfo()
                          : Container(),
                      _buildLocationAndDate(),
                      _buildPostContent(),
                    ],
                  ),
                ),
              ),
              post.imageUrl != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 10, bottom: 10, right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: GestureDetector(
                          onTap: () {
                            final imageProvider =
                                Image.network(post.imageUrl!).image;
                            showImageViewer(
                              context,
                              imageProvider,
                              swipeDismissible: true,
                              doubleTapZoomable: true,
                            );
                          },
                          child: Image.network(
                            post.imageUrl!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  ),
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                  padding: const EdgeInsets.all(4),
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.grey5,
                                  ),
                                  child: const Center(
                                      child: Text(
                                    'Unavailable',
                                    style: TextStyle(fontSize: 12),
                                  )));
                            },
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.person,
            size: 18,
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
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildPostTitle() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 2),
      child: Text(
        post.title,
        style: CustomFontStyles.postTitleLabel,
        maxLines: 2,
        softWrap: true,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildPostContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        post.text,
        style: CustomFontStyles.postContentText,
        textAlign: TextAlign.start,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildShareAndBookmark(),
              patternType == PostPatternType.postedPost
                  ? _buildEditAndDelete()
                  : Container(),
            ],
          ),
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

  Widget _buildEditAndDelete() {
    return Row(
      children: [
        Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(30.0),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.edit, size: 20),
                ))),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(30.0),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.delete_forever, size: 20),
              ),
            ),
          ),
        ),
        // IconButton(
        //   onPressed: () async {
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(
        //     //     builder: (context) => UpdatePostPage(post: post),
        //     //   ),
        //     // );
        //   },
        //   splashRadius: 1,
        //   icon: const Icon(Icons.edit, size: 20),
        // ),
        // IconButton(
        //   onPressed: () async {
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(
        //     //     builder: (context) => UpdatePostPage(post: post),
        //     //   ),
        //     // );
        //   },
        //   splashRadius: 1,
        //   icon: const Icon(Icons.delete_forever, size: 20),
        // ),
      ],
    );
  }
}
