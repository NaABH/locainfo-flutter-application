import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/firestore/database_provider.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/utilities/address_converter.dart';
import 'package:locainfo/utilities/distance_calculator.dart';

import 'database_constants.dart';

class FireStoreProvider implements DatabaseProvider {
  // implement FireStoreProvider as a singleton
  static final FireStoreProvider _shared = FireStoreProvider._sharedInstance();
  FireStoreProvider._sharedInstance();
  factory FireStoreProvider() => _shared;

  // post collection
  final posts = FirebaseFirestore.instance.collection('posts');

  @override
  Stream<Iterable<Post>> allPosts({required String ownerUserId}) => posts
      .snapshots()
      .map((event) => event.docs // see all changes that happen live
          .map((doc) => Post.fromSnapshot(doc))
          .where((post) =>
              post.ownerUserId == ownerUserId)); // posts created by the user

  @override
  Future<Post> createNewPost({
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
      source: '',
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      postedDate: postedTime,
    );
  }

  @override
  Future<void> deletePost({required String documentId}) async {
    try {
      posts.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeletePostException();
    }
  }

  @override
  Future<Iterable<Post>> getPosts({required String ownerUserId}) async {
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
      throw CouldNotGetAllPostsException();
    }
  }

  @override
  Future<void> updatePost({required String documentId, required text}) async {
    try {
      posts.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdatePostException();
    }
  }

  Stream<Iterable<Post>> getNearbyPosts(
          {required double userLat, required double userLng}) =>
      posts.snapshots().map((event) {
        return event.docs.map((doc) => Post.fromSnapshot(doc)).where((post) {
          // Calculate the distance between the post location and the user location
          var distance = calculateDistance(
              post.latitude, post.longitude, userLat, userLng);
          // Keep only the posts that are within 300 meters of the user location
          return distance <= 0.3;
        });
      });
}
