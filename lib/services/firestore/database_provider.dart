import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/services/firestore/current_user.dart';
import 'package:locainfo/services/firestore/post.dart';

abstract class DatabaseProvider {
  //--------------------------------User-----------------------------------
  // function to store user information when they first sign in
  Future<void> createNewUser({
    required String userId,
    required String username,
    required String emailAddress,
  });

  // get current user
  Future<CurrentUser> getUser({required String currentUserId});

  //--------------------------------Post-----------------------------------
  // function to create a new post
  Future<void> createNewPost({
    required String ownerUserId,
    required String ownerUserName,
    required String title,
    required String body,
    required String? imageUrl,
    required String category,
    required double latitude,
    required double longitude,
    required String locationName,
    required Timestamp postedDate,
  });

  // get all nearby posts
  Future<Iterable<Post>> getNearbyPosts({
    required Position position,
    required String currentUserId,
  });

  // get all posted posts
  Future<Iterable<Post>> getPostedPosts({required String currentUserId});

  // get post from text title (searching function)
  Future<Iterable<Post>> getSearchPosts(
      String searchText, String currentUserId, Position position);

  // get bookmark post ids
  Future<List<String>> getBookmarkedPostIds(String userId);

  // get post from bookmark ids
  Future<Iterable<Post>> getBookmarkedPosts(String currentUserId);

  // update post title and content
  Future<void> updatePostTitleContent({
    required String documentId,
    required String title,
    required String text,
  });

  // update post image
  Future<void> updatePostImage({
    required String documentId,
    required String? imageUrl,
  });

  // update post reactions
  Future<void> updatePostReactions({
    required String documentId,
    required String currentUserId,
    required UserAction action,
  });

  // clear all bookmarks
  Future<void> clearBookmarkList({required String currentUserId});

  // delete posts
  Future<void> deletePost({required String documentId});

//--------------------------------Report-----------------------------------
  Future<void> createNewReport({
    required String reporterId,
    required String postId,
    required String reason,
    required Timestamp reportDate,
  });
}
