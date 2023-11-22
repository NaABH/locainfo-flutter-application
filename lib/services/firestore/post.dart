import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:locainfo/services/firestore/database_constants.dart';

@immutable
class Post {
  final String documentId;
  final String ownerUserId;
  final String ownerUserName;
  final String title;
  final String text;
  final String category;
  final String source;
  final String latitude;
  final String longitude;

  const Post(
      {required this.documentId,
      required this.ownerUserId,
      required this.ownerUserName,
      required this.title,
      required this.text,
      required this.category,
      required this.source,
      required this.latitude,
      required this.longitude});

  Post.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        ownerUserName = snapshot.data()[ownerUserNameFieldName],
        title = snapshot.data()[titleFieldName] as String,
        text = snapshot.data()[textFieldName] as String,
        category = snapshot.data()[categoryFieldName] as String,
        source = snapshot.data()[sourceFieldName] as String,
        latitude = snapshot.data()[latitudeFieldName] as String,
        longitude = snapshot.data()[longitudeFieldName] as String;
}
