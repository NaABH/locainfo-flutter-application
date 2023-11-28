import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/constants/actions.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/firestore/database_provider.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/utilities/address_converter.dart';

import 'database_constants.dart';

class FireStoreProvider implements DatabaseProvider {
  // implement FireStoreProvider as a singleton
  static final FireStoreProvider _shared = FireStoreProvider._sharedInstance();
  FireStoreProvider._sharedInstance();
  factory FireStoreProvider() => _shared;

  // post collection in FireStore
  final posts = FirebaseFirestore.instance.collection('posts');
  final users = FirebaseFirestore.instance.collection('users');

  Future<Iterable<Post>> getSearchedPosts(
      String searchText, String currentUserId, Position position) async {
    try {
      var event =
          await posts.orderBy(postedDateFieldName, descending: true).get();
      return event.docs
          .map((doc) => Post.fromSnapshot(doc, currentUserId))
          .where((post) {
        // Check if the post title contains the searchText
        bool titleMatches =
            post.title.toLowerCase().contains(searchText.toLowerCase());

        // Calculate the distance between the post location and the user location
        var distance = Geolocator.distanceBetween(
          post.latitude,
          post.longitude,
          position.latitude,
          position.longitude,
        );

        // Keep only the posts that are within 300 meters and match the title search
        return distance <= 300 && titleMatches;
      });
    } on Exception catch (e) {
      throw CouldNotGetSearchedPostException();
    }
  }

  // get list of bookmarked posts id
  Future<List<String>> getBookmarkedPostIds(String userId) async {
    try {
      DocumentSnapshot userDoc = await users.doc(userId).get();

      if (userDoc.exists) {
        List<String> bookmarkedPostIds =
            List<String>.from(userDoc[bookmarkFieldName]);
        return bookmarkedPostIds;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw CouldNotGetBookmarkPostIdsException();
    }
  }

  // fetch the actual post from the list of bookmark post ids
  Future<Iterable<Post>> getBookmarkedPosts(
      List<String> bookmarkedPostIds, String currentUserId) async {
    try {
      if (bookmarkedPostIds.isEmpty) {
        return []; // Return an empty list if bookmarkedPostIds is empty
      }
      return await posts
          .where(FieldPath.documentId, whereIn: bookmarkedPostIds)
          .get()
          .then(
            (value) => value.docs.map((doc) => Post.fromSnapshot(doc,
                currentUserId)), // convert each document into a Post object
          );
    } catch (e) {
      throw CouldNotGetBookmarkPostException();
    }
  }

  // update bookmark list in the users collection
  Future<void> updateBookmarkList({
    required String documentId,
    required String currentUserId,
    required UserAction action,
  }) async {
    // Get the current list of bookmarked postIds
    List<String> currentBookmarkedPosts =
        await getBookmarkedPostIds(currentUserId);
    if (action == UserAction.bookmark) {
      // Add the new postId if it's not already in the list
      if (!currentBookmarkedPosts.contains(documentId)) {
        currentBookmarkedPosts.add(documentId);
      }
      // Update the 'bookmarked_posts' field in the user's document
      await users.doc(currentUserId).set(
        {bookmarkFieldName: currentBookmarkedPosts},
        SetOptions(merge: true),
      );
    } else {
      await users.doc(currentUserId).update({
        bookmarkFieldName: FieldValue.arrayRemove([documentId]),
      });
    }
  }

  @override
  Stream<Iterable<Post>> getPostedPostStream({required String currentUserId}) =>
      posts.orderBy(ownerUserIdFieldName).snapshots().map((event) {
        try {
          return event.docs // see all changes that happen live
              .map((doc) => Post.fromSnapshot(doc, currentUserId))
              .where((post) =>
                  post.ownerUserId ==
                  currentUserId); // posts created by the user
        } catch (e) {
          throw CouldNotGetPostsException();
        }
      });

  Future<Iterable<Post>> getPostedPosts({required String currentUserId}) async {
    try {
      return await posts
          .orderBy(ownerUserIdFieldName)
          .where(
            ownerUserIdFieldName,
            isEqualTo:
                currentUserId, //ownerUserIdFieldName equal to the ownerUserId
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => Post.fromSnapshot(doc,
                currentUserId)), // convert each document into a Post object
          );
    } catch (e) {
      throw CouldNotGetPostsException();
    }
  }

  @override
  Future<Iterable<Post>> getNearbyPosts({
    required double userLat,
    required double userLng,
    required String currentUserId,
  }) async {
    try {
      var event =
          await posts.orderBy(postedDateFieldName, descending: true).get();
      return event.docs
          .map((doc) => Post.fromSnapshot(doc, currentUserId))
          .where((post) {
        // Calculate the distance between the post location and the user location
        var distance = Geolocator.distanceBetween(
            post.latitude, post.longitude, userLat, userLng);
        // Keep only the posts that are within 300 meters of the user location
        return distance <= 300;
      });
    } catch (e) {
      throw CouldNotGetPostsException();
    }
  }

  Future<Iterable<Post>> getNearbyPosts2(
      {required Position position, required String currentUserId}) async {
    try {
      var event =
          await posts.orderBy(postedDateFieldName, descending: true).get();
      return event.docs
          .map((doc) => Post.fromSnapshot(doc, currentUserId))
          .where((post) {
        // Calculate the distance between the post location and the user location
        var distance = Geolocator.distanceBetween(
          post.latitude,
          post.longitude,
          position.latitude,
          position.longitude,
        );
        // Keep only the posts that are within 300 meters of the user location
        return distance <= 300;
      });
    } catch (e) {
      throw CouldNotGetPostsException();
    }
  }

  @override
  Stream<Iterable<Post>> getNearbyPostStream({
    required double userLat,
    required double userLng,
    required String currentUserId,
  }) =>
      posts
          .orderBy(postedDateFieldName, descending: true)
          .snapshots()
          .map((event) {
        try {
          return event.docs
              .map((doc) => Post.fromSnapshot(doc, currentUserId))
              .where((post) {
            // Calculate the distance between the post location and the user location
            var distance = Geolocator.distanceBetween(
                post.latitude, post.longitude, userLat, userLng);
            // Keep only the posts that are within 300 meters of the user location
            return distance <= 300;
          });
        } catch (e) {
          throw CouldNotGetPostsException();
        }
      });

  Future<void> updatePostLike({
    required String documentId,
    required String currentUserId,
    required UserAction action,
  }) async {
    if (action == UserAction.like) {
      await posts.doc(documentId).update({
        likedByFieldName: FieldValue.arrayUnion([currentUserId])
      });
    } else {
      await posts.doc(documentId).update({
        likedByFieldName: FieldValue.arrayRemove([currentUserId])
      });
    }
  }

  Future<void> updatePostDislike({
    required String documentId,
    required String currentUserId,
    required UserAction action,
  }) async {
    if (action == UserAction.dislike) {
      await posts.doc(documentId).update({
        dislikedByFieldName: FieldValue.arrayUnion([currentUserId])
      });
    } else {
      await posts.doc(documentId).update({
        dislikedByFieldName: FieldValue.arrayRemove([currentUserId])
      });
    }
  }

  // create a new post
  @override
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
  }) async {
    try {
      final post = await posts.add({
        ownerUserIdFieldName: ownerUserId,
        ownerUserNameFieldName: ownerUserName,
        titleFieldName: title,
        textFieldName: body,
        categoryFieldName: category,
        sourceFieldName: '',
        latitudeFieldName: latitude,
        longitudeFieldName: longitude,
        locationNameFieldName: locationName,
        postedDateFieldName: postedDate,
        likedByFieldName: [],
        dislikedByFieldName: [],
      });

      // final fetchedPost =
      //     await post.get(); // immediately fetch back from the FireStore
      // DateTime postedTime = postedDate.toDate();
      // return Post(
      //   documentId: fetchedPost.id,
      //   ownerUserId: ownerUserId,
      //   ownerUserName: ownerUserName,
      //   title: title,
      //   text: body,
      //   category: category,
      //   latitude: latitude,
      //   longitude: longitude,
      //   locationName: locationName,
      //   postedDate: postedTime,
      // );
    } catch (e) {
      throw CouldNotCreatePostException();
    }
  }

  Future<Post> createNewPost1({
    required String ownerUserId,
    required String ownerUserName,
    required String title,
    required String body,
    required String category,
    required double latitude,
    required double longitude,
    required Timestamp postedDate,
  }) async {
    final locationName = await getLocationName(latitude, longitude);
    final document = await posts.add({
      ownerUserIdFieldName: ownerUserId,
      ownerUserNameFieldName: ownerUserName,
      titleFieldName: title,
      textFieldName: body,
      categoryFieldName: category,
      sourceFieldName: '',
      latitudeFieldName: latitude,
      longitudeFieldName: longitude,
      locationNameFieldName: locationName,
      postedDateFieldName: postedDate,
    });
    final fetchedNote =
        await document.get(); // immediately fetch back from the FireStore
    DateTime postedTime = postedDate.toDate();
    return Post(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      ownerUserName: ownerUserName,
      title: title,
      text: body,
      category: category,
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      postedDate: postedTime,
      isLiked: false,
      numberOfLikes: 0,
      isDisliked: false,
      numberOfDislikes: 0,
    );
  }

  // // delete Post
  // @override
  // Future<void> deletePost({required String documentId}) async {
  //   try {
  //     posts.doc(documentId).delete();
  //   } catch (e) {
  //     throw CouldNotDeletePostException();
  //   }
  // }
  //
  // // update post
  // @override
  // Future<void> updatePost({required String documentId, required text}) async {
  //   try {
  //     posts.doc(documentId).update({textFieldName: text});
  //   } catch (e) {
  //     throw CouldNotUpdatePostException();
  //   }
  // }
}
