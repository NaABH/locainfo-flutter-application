import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/components/my_post.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/utilities/post_sorter.dart';

// call when user press the post
typedef PostCallBack = void Function(Post post);

// generate a list view of post
class MyPostList extends StatelessWidget {
  final Position? currentPosition;
  final Iterable<Post> posts;
  final PostCallBack onTap;
  final String? selectedCategory;
  final String? selectedSortBy;
  final PostPatternType postPatternType;
  final ScrollController? scrollController;

  const MyPostList({
    Key? key,
    required this.posts,
    required this.onTap,
    required this.postPatternType,
    this.selectedCategory,
    this.selectedSortBy,
    this.currentPosition,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // sort the posts
    final sortedPosts = sortPosts(posts, selectedSortBy);

    // Filter posts based on the selected category
    final filteredPosts = selectedCategory != null
        ? sortedPosts.where((post) => post.category == selectedCategory)
        : sortedPosts.toList();

    return filteredPosts.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            controller: scrollController,
            key: key,
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = sortedPosts.elementAt(index);
              return MyPost(
                key: ValueKey(
                    post.documentId), // Provide a unique key for each post
                post: post,
                currentPosition: currentPosition,
                onTap: onTap,
                patternType: postPatternType,
              );
            },
          );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('No posts available for the selected category'),
    );
  }
}
