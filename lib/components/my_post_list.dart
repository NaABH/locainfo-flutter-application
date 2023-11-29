import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/components/my_post.dart';
import 'package:locainfo/constants/actions.dart';
import 'package:locainfo/services/firestore/post.dart';

// call when user press the post
typedef PostCallBack = void Function(Post post);

// generate a list view of post
class MyPostList extends StatelessWidget {
  final Position? currentPosition;
  final Iterable<Post> posts;
  final List<String> bookmarkedPosts;
  final PostCallBack onTap;
  final String? selectedCategory; // New parameter for selected category
  final PostPatternType postPatternType;

  const MyPostList({
    Key? key,
    required this.posts,
    required this.onTap,
    required this.bookmarkedPosts,
    this.selectedCategory,
    required this.postPatternType,
    this.currentPosition, // Provide a default value if needed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter posts based on the selected category
    final filteredPosts = selectedCategory != null
        ? posts.where((post) => post.category == selectedCategory)
        : posts.toList();

    return filteredPosts.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            key: key,
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts.elementAt(index);
              return MyPost(
                post: post,
                currentPosition: currentPosition,
                isBookMarked: bookmarkedPosts.contains(post.documentId),
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
