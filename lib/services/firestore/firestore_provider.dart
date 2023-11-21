import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/firestore/database_provider.dart';
import 'package:locainfo/services/firestore/post.dart';

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
  Future<Post> createNewPost({required String ownerUserId}) async {
    final document = await posts.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: '',
      textFieldName: '',
      categoryFieldName: '',
      sourceFieldName: '',
      latitudeFieldName: '', // to be completed
      longitudeFieldName: '', // to be completed
    });
    final fetchedNote =
        await document.get(); // immediately fetch back from the FireStore
    return Post(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      title: '',
      text: '',
      category: '',
      source: '',
      latitude: '',
      longitude: '',
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
}
