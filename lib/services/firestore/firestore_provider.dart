import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/firestore/database_provider.dart';
import 'package:locainfo/services/firestore/post.dart';

import '../../utilities/address_converter.dart';
import 'database_constants.dart';

class FireStoreProvider implements DatabaseProvider {
  // implement FireStoreProvider as a singleton
  static final FireStoreProvider _shared = FireStoreProvider._sharedInstance();
  FireStoreProvider._sharedInstance();
  factory FireStoreProvider() => _shared;

  // post collection in FireStore
  final posts = FirebaseFirestore.instance.collection('posts');

  @override
  Stream<Iterable<Post>> getPostedPostStream({required String ownerUserId}) =>
      posts.snapshots().map((event) {
        try {
          return event.docs // see all changes that happen live
              .map((doc) => Post.fromSnapshot(doc))
              .where((post) =>
                  post.ownerUserId == ownerUserId); // posts created by the user
        } catch (e) {
          throw CouldNotGetPostsException();
        }
      });

  Future<Iterable<Post>> getPostedPosts({required String ownerUserId}) async {
    try {
      return await posts
          .where(
            ownerUserIdFieldName,
            isEqualTo:
                ownerUserId, //ownerUserIdFieldName equal to the ownerUserId
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => Post.fromSnapshot(
                doc)), // convert each document into a Post object
          );
    } catch (e) {
      throw CouldNotGetPostsException();
    }
  }

  @override
  Future<Iterable<Post>> getNearbyPosts({
    required double userLat,
    required double userLng,
  }) async {
    try {
      var event = await posts.get();
      return event.docs.map((doc) => Post.fromSnapshot(doc)).where((post) {
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

  Future<Iterable<Post>> getNearbyPosts2({required Position position}) async {
    try {
      var event = await posts.get();
      return event.docs.map((doc) => Post.fromSnapshot(doc)).where((post) {
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
  }) =>
      posts.snapshots().map((event) {
        try {
          return event.docs.map((doc) => Post.fromSnapshot(doc)).where((post) {
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
