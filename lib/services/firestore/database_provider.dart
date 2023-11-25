import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locainfo/services/firestore/post.dart';

abstract class DatabaseProvider {
  // create new post
  Future<void> createNewPost({
    required String ownerUserId,
    required String ownerUserName,
    required String title,
    required String body,
    required String category,
    required double latitude,
    required double longitude,
    required String locationName,
    required Timestamp postedDate,
  });

  // // get posts
  // Future<Iterable<Post>> getPosts({required String ownerUserId});

  // get all nearby posts
  Future<Iterable<Post>> getNearbyPosts(
      {required double userLat, required double userLng});

  Stream<Iterable<Post>> getNearbyPostStream(
      {required double userLat, required double userLng});

  // get all posts posted by the user
  Stream<Iterable<Post>> getPostedPostStream({required String ownerUserId});

  // // update posts
  // Future<void> updatePost({required String documentId, required text});
  //
  // // delete posts
  // Future<void> deletePost({required String documentId});
}
