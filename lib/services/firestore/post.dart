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
  final String? imageUrl;
  final String category;
  final double latitude;
  final double longitude;
  final String locationName;
  final DateTime postedDate;
  final bool isLiked;
  final int numberOfLikes;
  final bool isDisliked;
  final int numberOfDislikes;
  final bool isBookmarked;

  const Post(
      {required this.documentId,
      required this.ownerUserId,
      required this.ownerUserName,
      required this.title,
      required this.text,
      required this.imageUrl,
      required this.category,
      required this.latitude,
      required this.longitude,
      required this.locationName,
      required this.postedDate,
      required this.isLiked,
      required this.numberOfLikes,
      required this.isDisliked,
      required this.numberOfDislikes,
      required this.isBookmarked});

  Post.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    String currentUserId,
    List<String> bookmarkedPostIds,
  )   : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        ownerUserName = snapshot.data()[ownerUserNameFieldName] as String,
        title = snapshot.data()[titleFieldName] as String,
        text = snapshot.data()[textFieldName] as String,
        imageUrl = snapshot.data()[imageLinkFieldName] as String?,
        category = snapshot.data()[categoryFieldName] as String,
        latitude = snapshot.data()[latitudeFieldName] as double,
        longitude = snapshot.data()[longitudeFieldName] as double,
        locationName = snapshot.data()[locationNameFieldName] as String,
        postedDate =
            (snapshot.data()[postedDateFieldName] as Timestamp).toDate(),
        isLiked =
            (snapshot.data()[likedByFieldName] as List).contains(currentUserId),
        numberOfLikes = (snapshot.data()[likedByFieldName] as List).length,
        isDisliked = (snapshot.data()[dislikedByFieldName] as List)
            .contains(currentUserId),
        numberOfDislikes =
            (snapshot.data()[dislikedByFieldName] as List).length,
        isBookmarked = bookmarkedPostIds.contains(snapshot.id);

  String get timeAgo {
    return dateTimeFormatter(postedDate);
  }
}
