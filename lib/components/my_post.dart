import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/components/my_bookmark_button.dart';
import 'package:locainfo/components/my_home_post_list.dart';
import 'package:locainfo/components/my_likedislike_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/pages/app/update_post_page.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/utilities/dialog/delete_dialog.dart';
import 'package:locainfo/utilities/post_info_helper.dart';
import 'package:share_plus/share_plus.dart';

class MyPost extends StatefulWidget {
  final Position? currentPosition;
  final Post post;
  final PostCallBack onTap;
  final PostPatternType patternType;
  const MyPost({
    Key? key,
    required this.post,
    required this.onTap,
    required this.patternType,
    required this.currentPosition,
  }) : super(key: key);

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  late Post currentPost;

  @override
  void initState() {
    currentPost = widget.post;
    super.initState();
  }

  void updatePostState(Post updatedPost) {
    setState(() {
      currentPost = updatedPost;
    });
  }

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
                widget.onTap(currentPost);
              },
              child: _buildPostTitle()),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onTap(currentPost);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (widget.patternType != PostPatternType.userPosted &&
                              widget.patternType != PostPatternType.home)
                          ? _buildUserInfo()
                          : Container(),
                      widget.patternType != PostPatternType.home &&
                              widget.patternType != PostPatternType.news
                          ? _buildLocationAndDate()
                          : _buildDistanceAndDate(),
                      _buildPostContent(),
                    ],
                  ),
                ),
              ),
              currentPost.imageUrl != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 10, bottom: 10, right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: GestureDetector(
                          onTap: () {
                            final imageProvider =
                                Image.network(currentPost.imageUrl!).image;
                            showImageViewer(
                              context,
                              imageProvider,
                              swipeDismissible: true,
                              doubleTapZoomable: true,
                            );
                          },
                          child: Image.network(
                            currentPost.imageUrl!,
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
                                    height: 60,
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
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
                                    style: TextStyle(fontSize: 11),
                                  )));
                            },
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLikeDislikeButton(),
                Row(
                  children: [
                    _buildShareAndBookmark(),
                    widget.patternType == PostPatternType.userPosted
                        ? Row(
                            children: [
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdatePostPage(
                                                    post: currentPost),
                                          ),
                                        );
                                      },
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
                                    onTap: () async {
                                      final wantDelete =
                                          await showDeleteDialog(context);
                                      if (wantDelete) {
                                        context.read<PostBloc>().add(
                                            PostEventDeletePost(
                                                currentPost.documentId));
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5),
                                      child:
                                          Icon(Icons.delete_forever, size: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
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
          currentPost.ownerProfilePicUrl == null
              ? const Icon(
                  Icons.person,
                  size: 18,
                )
              : CircleAvatar(
                  radius: 9,
                  backgroundImage:
                      NetworkImage(currentPost.ownerProfilePicUrl!),
                ),
          const SizedBox(width: 8),
          Text(
            currentPost.ownerUserName,
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
        '${currentPost.locationName}, ${currentPost.timeAgo}',
        style: CustomFontStyles.postLocationDateLabel,
        maxLines: 1,
        softWrap: true,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildDistanceAndDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '${getDistanceText(widget.currentPosition!, currentPost.latitude, currentPost.longitude)}, ${currentPost.timeAgo}',
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
        currentPost.title,
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
        currentPost.content,
        style: CustomFontStyles.postContentText,
        textAlign: TextAlign.start,
        maxLines: 3,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildLikeDislikeButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyLikeDislikeButton(
          post: currentPost,
          onUpdatePostState: updatePostState,
        ),
      ],
    );
  }

  Widget _buildShareAndBookmark() {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            await Share.share('${currentPost.title}\n${currentPost.content}');
          },
          splashRadius: 1,
          icon: const Icon(Icons.share, size: 20),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: MyBookmarkButton(
            post: currentPost,
            onUpdatePostState: updatePostState,
          ),
        ),
      ],
    );
  }
}
