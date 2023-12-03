import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/services/firestore/current_user.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/firestore/database_provider.dart';
import 'package:locainfo/services/firestore/post.dart';

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

  // Use to filter the post which is posted 3 months ago (approximate 90 days) and 300m away
  DateTime dateFiltering = DateTime.now().subtract(const Duration(days: 90));
  int distanceFiltering = 400;

  // get nearby post (sort by distance)
  @override
  Future<List<Post>> getNearbyPosts({
    required Position position,
    required String currentUserId,
  }) async {
    try {
      final bookmarkedPostIds = await getBookmarkedPostIds(currentUserId);
      var event = await posts
          .where(postedDateFieldName,
              isGreaterThan: Timestamp.fromDate(dateFiltering))
          .get();
      return event.docs
          .map((doc) => Post.fromSnapshot(
              doc, currentUserId, bookmarkedPostIds, position))
          .where((post) {
        // distance filtering
        return post.distance! <= distanceFiltering;
      }).toList()
        ..sort((a, b) {
          // sort by distance
          return a.distance!.compareTo(b.distance!);
        });
    } on Exception catch (_) {
      throw CouldNotGetPostsException();
    }
  }

  // get posted post (sort by posted date (newer first))
  @override
  Future<List<Post>> getPostedPosts({required String currentUserId}) async {
    try {
      final event = await posts
          .where(
            ownerUserIdFieldName,
            isEqualTo: currentUserId,
          )
          .orderBy(postedDateFieldName, descending: true)
          .get();
      final bookmarkedPostIds = await getBookmarkedPostIds(currentUserId);
      final postsList = event.docs
          .map((doc) =>
              Post.fromSnapshot(doc, currentUserId, bookmarkedPostIds, null))
          .toList();
      return postsList;
    } on Exception catch (_) {
      throw CouldNotGetPostsException();
    }
  }

  // -----------------------------Post-------------------------------
  // create post
  @override
  Future<void> createNewPost({
    required String ownerUserId,
    required String ownerUserName,
    required String? ownerProfilePicUrl,
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
      await posts.add({
        ownerUserIdFieldName: ownerUserId,
        ownerUserNameFieldName: ownerUserName,
        ownerProfilePictureFieldName: ownerProfilePicUrl,
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
    } on Exception catch (_) {
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
    } on Exception catch (_) {
      throw CouldNotUpdatePostException();
    }
  }

  // update post: image
  @override
  Future<void> updatePostImage({
    required String documentId,
    required String? imageUrl,
  }) async {
    try {
      await posts.doc(documentId).update({
        imageLinkFieldName: imageUrl,
      });
    } on Exception catch (_) {
      throw CouldNotUpdatePostException();
    }
  }

  // delete post
  @override
  Future<void> deletePost({required String documentId}) async {
    try {
      posts.doc(documentId).delete();
    } on Exception catch (e) {
      throw CouldNotDeletePostException();
    }
  }

  // update post reactions
  @override
  Future<void> updatePostReactions({
    required String documentId,
    required String currentUserId,
    required UserAction action,
  }) async {
    try {
      // user like
      if (action == UserAction.like) {
        await posts.doc(documentId).update({
          likedByFieldName: FieldValue.arrayUnion([currentUserId])
        });
      }
      // remove like
      else if (action == UserAction.unlike) {
        await posts.doc(documentId).update({
          likedByFieldName: FieldValue.arrayRemove([currentUserId])
        });
      }
      // dislike
      else if (action == UserAction.dislike) {
        await posts.doc(documentId).update({
          dislikedByFieldName: FieldValue.arrayUnion([currentUserId])
        });
      }
      // remove dislike
      else if (action == UserAction.removeDislike) {
        await posts.doc(documentId).update({
          dislikedByFieldName: FieldValue.arrayRemove([currentUserId])
        });
      }
      // bookmark
      else if (action == UserAction.bookmark) {
        final currentBookmarkedPosts =
            await getBookmarkedPostIds(currentUserId);
        if (!currentBookmarkedPosts.contains(documentId)) {
          currentBookmarkedPosts.add(documentId);
        }
        await users.doc(currentUserId).set(
          {bookmarkFieldName: currentBookmarkedPosts},
          SetOptions(merge: true),
        );
      }
      // remove bookmark
      else {
        await users.doc(currentUserId).update({
          bookmarkFieldName: FieldValue.arrayRemove([documentId]),
        });
      }
    } on Exception catch (_) {
      throw CouldNotUpdatePostReactionsException();
    }
  }

  // searching function
  @override
  Future<List<Post>> getSearchPosts(
      String searchText, String currentUserId, Position position) async {
    try {
      final bookmarkedPostIds = await getBookmarkedPostIds(currentUserId);
      var event = await posts
          .where(postedDateFieldName,
              isGreaterThan: Timestamp.fromDate(dateFiltering))
          .orderBy(postedDateFieldName, descending: true)
          .get();
      return event.docs
          .map((doc) => Post.fromSnapshot(
                doc,
                currentUserId,
                bookmarkedPostIds,
                null,
              ))
          .where((post) {
        // Check if the post title contains the searchText
        bool titleMatches =
            post.title.toLowerCase().contains(searchText.toLowerCase());

        var distance = Geolocator.distanceBetween(
          post.latitude,
          post.longitude,
          position.latitude,
          position.longitude,
        );

        // Keep only the posts that are within 300 meters and match the title search
        return distance <= distanceFiltering && titleMatches;
      }).toList();
    } on Exception catch (_) {
      throw CouldNotGetSearchedPostException();
    }
  }

  // get bookmark post ids
  @override
  Future<List<String>> getBookmarkedPostIds(String userId) async {
    try {
      DocumentSnapshot userDoc = await users.doc(userId).get();

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      if (userData.containsKey(bookmarkFieldName)) {
        final bookmarkedPostIds =
            List<String>.from(userData[bookmarkFieldName]);
        return bookmarkedPostIds;
      } else {
        // Bookmark field does not exist, return empty array
        return [];
      }
    } on Exception catch (_) {
      throw CouldNotGetBookmarkPostIdsException();
    }
  }

  // get post from bookmark id
  @override
  Future<List<Post>> getBookmarkedPosts(String currentUserId) async {
    try {
      final bookmarkedPostIds = await getBookmarkedPostIds(currentUserId);

      if (bookmarkedPostIds.isEmpty) {
        return []; // Return an empty list if bookmarkedPostIds is empty
      }
      return await posts
          .where(FieldPath.documentId, whereIn: bookmarkedPostIds)
          .get()
          .then(
            (value) => value.docs
                .map((doc) => Post.fromSnapshot(
                    doc, currentUserId, bookmarkedPostIds, null))
                .toList(), // convert each document into a Post object
          );
    } on Exception catch (_) {
      throw CouldNotGetBookmarkPostException();
    }
  }

  // Clear all bookmark
  @override
  Future<void> clearBookmarkList({required String currentUserId}) async {
    try {
      await users.doc(currentUserId).update({
        bookmarkFieldName: [],
      });
    } on Exception catch (_) {
      throw CouldNotClearBookmarkException();
    }
  }

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
        await users.doc(userId).set({
          usernameFieldName: username,
          emailAddressFieldName: emailAddress,
          registerDateFieldName: Timestamp.fromDate(DateTime.now()),
        });
      }
    } on Exception catch (_) {
      throw CouldNotCreateNewUserException();
    }
  }

  // get user
  @override
  Future<CurrentUser> getUser({required String currentUserId}) async {
    try {
      DocumentSnapshot userDoc = await users.doc(currentUserId).get();
      return CurrentUser.fromSnapshot(userDoc);
    } on Exception catch (_) {
      throw CouldNotGetUserException();
    }
  }

  // update profile picture
  @override
  Future<void> updateProfilePicture({
    required String currentUserId,
    required String imageUrl,
  }) async {
    try {
      await users.doc(currentUserId).update({
        profilePictureFieldName: imageUrl,
      });
      final querySnapshot = await posts
          .where(ownerUserIdFieldName, isEqualTo: currentUserId)
          .get();

      // Update ownerUsername in each post
      for (final doc in querySnapshot.docs) {
        await posts.doc(doc.id).update({
          ownerProfilePictureFieldName: imageUrl,
        });
      }
    } on Exception catch (_) {
      throw CouldNotUpdateProfilePictureException();
    }
  }

  // update username
  @override
  Future<void> updateUsername({
    required String currentUserId,
    required String newUsername,
  }) async {
    try {
      await users.doc(currentUserId).update({
        usernameFieldName: newUsername,
      });

      final querySnapshot = await posts
          .where(ownerUserIdFieldName, isEqualTo: currentUserId)
          .get();

      // Update ownerUsername in each post
      for (final doc in querySnapshot.docs) {
        await posts.doc(doc.id).update({
          ownerUserNameFieldName: newUsername,
        });
      }
    } on Exception catch (_) {
      throw CouldNotUpdateUsernameException();
    }
  }

  // -----------------------------Report-------------------------------
  @override
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
    } on Exception catch (_) {
      throw CouldNotCreateReportException();
    }
  }
}
