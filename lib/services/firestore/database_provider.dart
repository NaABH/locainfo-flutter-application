import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/firestore/user.dart';

abstract class DatabaseProvider {
  // User Related
  // function to store user information when they first sign in
  Future<void> createNewUser({
    required String userId,
    required String username,
    required String emailAddress,
  });

  // Post Related
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

  Stream<Iterable<Post>> getNearbyPostStream({
    required double userLat,
    required double userLng,
    required String currentUserId,
  });

  // get all posts posted by the user
  Stream<Iterable<Post>> getPostedPostStream({required String currentUserId});

  // update posts
  Future<void> updatePostTitleContent({
    required String documentId,
    required String title,
    required String text,
  });

  Future<CurrentUser> getUser({required String currentUserId});

  // delete posts
  Future<void> deletePost({required String documentId});
}
