import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/firestore/database_provider.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/firestore/user.dart';

import 'database_constants.dart';

class FireStoreProvider implements DatabaseProvider {
  // implement FireStoreProvider as a singleton
  static final FireStoreProvider _shared = FireStoreProvider._sharedInstance();
  FireStoreProvider._sharedInstance();
  factory FireStoreProvider() => _shared;

  // collections in FireStore
  final posts = FirebaseFirestore.instance.collection(postsCollectionName);
  final users = FirebaseFirestore.instance.collection(userCollectionName);
  final reports = FirebaseFirestore.instance.collection(reportCollectionName);

  // get nearby post
  @override
  Future<Iterable<Post>> getNearbyPosts({
    required Position position,
    required String currentUserId,
  }) async {
    try {
      final bookmarkedPostIds = await getBookmarkedPostIds(currentUserId);
      var event =
          await posts.orderBy(postedDateFieldName, descending: true).get();
      return event.docs
          .map(
              (doc) => Post.fromSnapshot(doc, currentUserId, bookmarkedPostIds))
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

  // get posted post
  Future<Iterable<Post>> getPostedPosts({required String currentUserId}) async {
    try {
      var querySnapshot = await posts
          .where(
            ownerUserIdFieldName,
            isEqualTo: currentUserId,
          )
          .get();
      final bookmarkedPostIds = await getBookmarkedPostIds(currentUserId);
      var postsList = querySnapshot.docs
          .map(
              (doc) => Post.fromSnapshot(doc, currentUserId, bookmarkedPostIds))
          .toList();

      // Order posts by postCreatedDate in descending order
      postsList.sort((a, b) => b.postedDate.compareTo(a.postedDate));

      return postsList;
    } catch (e) {
      throw CouldNotGetPostsException();
    }
  }

  // -----------------------------Post-------------------------------
  // create post
  @override
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
  }) async {
    try {
      final post = await posts.add({
        ownerUserIdFieldName: ownerUserId,
        ownerUserNameFieldName: ownerUserName,
        titleFieldName: title,
        textFieldName: body,
        categoryFieldName: category,
        imageLinkFieldName: imageUrl,
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

  // update post: title and content
  @override
  Future<void> updatePostTitleContent({
    required String documentId,
    required String title,
    required String text,
  }) async {
    try {
      await posts.doc(documentId).update({
        titleFieldName: title,
        textFieldName: text,
      });
    } catch (e) {
      throw CouldNotUpdatePostException();
    }
  }

  // update post: image
  Future<void> updatePostImage({
    required String documentId,
    required String? imageUrl,
  }) async {
    try {
      await posts.doc(documentId).update({
        imageLinkFieldName: imageUrl,
      });
    } catch (e) {
      throw CouldNotUpdatePostException();
    }
  }

  // delete post
  @override
  Future<void> deletePost({required String documentId}) async {
    try {
      posts.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeletePostException();
    }
  }

  // Post interaction: Like
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

  // Post interaction: DisLike
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

  // Post interaction: bookmark
  Future<void> updateBookmarkList({
    required String documentId,
    required String currentUserId,
    required UserAction action,
  }) async {
    // Get the current list of bookmarked postIds
    final currentBookmarkedPosts = await getBookmarkedPostIds(currentUserId);
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
    } else if (action == UserAction.removeBookmark) {
      await users.doc(currentUserId).update({
        bookmarkFieldName: FieldValue.arrayRemove([documentId]),
      });
    }
  }

  // searching function
  Future<Iterable<Post>> getSearchPosts(
      String searchText, String currentUserId, Position position) async {
    try {
      final bookmarkedPostIds = await getBookmarkedPostIds(currentUserId);

      var event =
          await posts.orderBy(postedDateFieldName, descending: true).get();
      return event.docs
          .map((doc) => Post.fromSnapshot(
                doc,
                currentUserId,
                bookmarkedPostIds,
              ))
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

  // bookmark id
  Future<List<String>> getBookmarkedPostIds(String userId) async {
    try {
      DocumentSnapshot userDoc = await users.doc(userId).get();

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      if (userData.containsKey(bookmarkFieldName)) {
        final bookmarkedPostIds =
            List<String>.from(userData[bookmarkFieldName]);
        return bookmarkedPostIds;
      } else {
        // Bookmark field doesn't exist, return empty array
        return [];
      }
    } on Exception catch (e) {
      throw CouldNotGetBookmarkPostIdsException();
    }
  }

  // post from bookmark id
  Future<Iterable<Post>> getBookmarkedPosts(String currentUserId) async {
    try {
      final bookmarkedPostIds = await getBookmarkedPostIds(currentUserId);

      if (bookmarkedPostIds.isEmpty) {
        return []; // Return an empty list if bookmarkedPostIds is empty
      }
      return await posts
          .where(FieldPath.documentId, whereIn: bookmarkedPostIds)
          .get()
          .then(
            (value) => value.docs.map((doc) => Post.fromSnapshot(
                doc,
                currentUserId,
                bookmarkedPostIds)), // convert each document into a Post object
          );
    } catch (e) {
      throw CouldNotGetBookmarkPostException();
    }
  }

  // Clear all bookmark
  Future<void> clearBookmarkList({required String currentUserId}) async {
    try {
      await users.doc(currentUserId).update({
        bookmarkFieldName: [],
      });
    } on Exception catch (e) {
      throw CouldClearBookmarkException();
    }
  }

  // ?
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
              .map((doc) => Post.fromSnapshot(doc, currentUserId, []))
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

  @override
  Stream<Iterable<Post>> getPostedPostStream({required String currentUserId}) =>
      posts.orderBy(ownerUserIdFieldName).snapshots().map((event) {
        try {
          return event.docs // see all changes that happen live
              .map((doc) => Post.fromSnapshot(doc, currentUserId, []))
              .where((post) =>
                  post.ownerUserId ==
                  currentUserId); // posts created by the user
        } catch (e) {
          throw CouldNotGetPostsException();
        }
      });

  // -----------------------------User---------------------------------
  // create user
  @override
  Future<void> createNewUser({
    required String userId,
    required String username,
    required String emailAddress,
  }) async {
    try {
      DocumentSnapshot userDoc = await users.doc(userId).get();
      if (!userDoc.exists) {
        Timestamp currentDateTime = Timestamp.fromDate(DateTime.now());
        await users.doc(userId).set({
          usernameFieldName: username,
          emailAddressFieldName: emailAddress,
          registerDateFieldName: currentDateTime,
        });
      }
    } on Exception catch (e) {
      throw CouldNotCreateNewUserException();
    }
  }

  // get user
  Future<CurrentUser> getUser({required String currentUserId}) async {
    try {
      DocumentSnapshot userDoc = await users.doc(currentUserId).get();
      return CurrentUser.fromSnapshot(userDoc);
    } on Exception catch (_) {
      throw CouldNotGetUserException();
    }
  }

  // -----------------------------Report-------------------------------
  Future<void> createNewReport({
    required String reporterId,
    required String postId,
    required String reason,
    required Timestamp reportDate,
  }) async {
    try {
      await reports.add({
        reporterUserIdFieldName: reporterId,
        reportPostIdFieldName: postId,
        reasonFieldName: reason,
        reportDateFieldName: reportDate,
      });
    } on Exception catch (e) {
      throw CouldNotCreateReportException();
    }
  }
}
