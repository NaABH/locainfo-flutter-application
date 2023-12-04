import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/pages/app/report_page.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:share_plus/share_plus.dart';

// A custom bottom bar to be used in the post detail page
class MyBottomBar extends StatefulWidget {
  final Post post;
  final Function(Post) onUpdatePostState;
  const MyBottomBar({
    super.key,
    required this.post,
    required this.onUpdatePostState,
  });

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  late final Post post = widget.post;
  late bool isBookmarked = widget.post.isBookmarked;
  late bool isLiked = widget.post.isLiked;
  late bool isDisliked = widget.post.isDisliked;
  late int numberOfLikes = widget.post.numberOfLikes;
  late int numberOfDislikes = widget.post.numberOfDislikes;

  void _removeLiked() {
    if (isLiked) {
      isLiked = !isLiked;
      numberOfLikes = isLiked ? numberOfLikes + 1 : numberOfLikes - 1;
      context.read<PostBloc>().add(
          PostEventUpdatePostReactions(post.documentId, UserAction.unlike));
    }
  }

  void _removeDisliked() {
    if (isDisliked) {
      isDisliked = !isDisliked;
      numberOfDislikes =
          isDisliked ? numberOfDislikes + 1 : numberOfDislikes - 1;
      context.read<PostBloc>().add(PostEventUpdatePostReactions(
          post.documentId, UserAction.removeDislike));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.grey3,
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isLiked = !isLiked;
                numberOfLikes = isLiked ? numberOfLikes + 1 : numberOfLikes - 1;
                context.read<PostBloc>().add(isLiked
                    ? PostEventUpdatePostReactions(
                        post.documentId, UserAction.like)
                    : PostEventUpdatePostReactions(
                        post.documentId, UserAction.unlike));

                // remove the disliked if it is enabled
                _removeDisliked();

                widget.onUpdatePostState(
                  Post(
                    documentId: widget.post.documentId,
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
                    isDisliked: isDisliked,
                    numberOfLikes: numberOfLikes,
                    numberOfDislikes: numberOfDislikes,
                    isBookmarked: isBookmarked,
                  ),
                );
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
                    ? PostEventUpdatePostReactions(
                        post.documentId, UserAction.dislike)
                    : PostEventUpdatePostReactions(
                        post.documentId, UserAction.removeDislike));

                // remove like if enabled
                _removeLiked();

                widget.onUpdatePostState(
                  Post(
                    documentId: widget.post.documentId,
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
                    isDisliked: isDisliked,
                    numberOfLikes: numberOfLikes,
                    numberOfDislikes: numberOfDislikes,
                    isBookmarked: isBookmarked,
                  ),
                );
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
              await Share.share('${post.title}\n${post.content}');
            },
            child: const Icon(Icons.share),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isBookmarked = !isBookmarked;
                // update the database, add bookmark
                if (isBookmarked) {
                  context.read<PostBloc>().add(PostEventUpdatePostReactions(
                      post.documentId, UserAction.bookmark));
                } else {
                  // update the database, remove bookmark
                  context.read<PostBloc>().add(PostEventUpdatePostReactions(
                      post.documentId, UserAction.removeBookmark));
                }

                widget.onUpdatePostState(
                  Post(
                    documentId: widget.post.documentId,
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
                    isDisliked: isDisliked,
                    numberOfLikes: numberOfLikes,
                    numberOfDislikes: numberOfDislikes,
                    isBookmarked: isBookmarked,
                  ),
                );
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
