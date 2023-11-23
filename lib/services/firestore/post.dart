import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:locainfo/services/firestore/database_constants.dart';
import 'package:locainfo/utilities/datetime_formatter.dart';

@immutable
class Post {
  final String documentId;
  final String ownerUserId;
  final String ownerUserName;
  final String title;
  final String text;
  final String category;
  final String source;
  final double latitude;
  final double longitude;
  final String locationName;
  final DateTime postedDate;

  const Post(
      {required this.documentId,
      required this.ownerUserId,
      required this.ownerUserName,
      required this.title,
      required this.text,
      required this.category,
      required this.source,
      required this.latitude,
      required this.longitude,
      required this.locationName,
      required this.postedDate});

  Post.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        ownerUserName = snapshot.data()[ownerUserNameFieldName] as String,
        title = snapshot.data()[titleFieldName] as String,
        text = snapshot.data()[textFieldName] as String,
        category = snapshot.data()[categoryFieldName] as String,
        source = snapshot.data()[sourceFieldName] as String,
        latitude = snapshot.data()[latitudeFieldName] as double,
        longitude = snapshot.data()[longitudeFieldName] as double,
        locationName = snapshot.data()[locationNameFieldName] as String,
        postedDate =
            (snapshot.data()[postedDateFieldName] as Timestamp).toDate();

  String get timeAgo {
    return dateTimeFormatter(postedDate);
  }
}
