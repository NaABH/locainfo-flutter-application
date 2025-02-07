import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/services/firestore/database_constants.dart';
import 'package:locainfo/utilities/post_info_helper.dart';

// class to store store value retrieve from the fireStore
@immutable
class Post {
  final String documentId;
  final String ownerUserId;
  final String ownerUserName;
  final String? ownerProfilePicUrl;
  final String title;
  final String content;
  final String? imageUrl;
  final String? contact;
  final String category;
  final double latitude;
  final double longitude;
  final int? distance;
  final String locationName;
  final DateTime postedDate;
  final bool isLiked;
  final int numberOfLikes;
  final bool isDisliked;
  final int numberOfDislikes;
  final bool isBookmarked;

  const Post({
    required this.documentId,
    required this.ownerUserId,
    required this.ownerUserName,
    required this.ownerProfilePicUrl,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.contact,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.distance,
    required this.locationName,
    required this.postedDate,
    required this.isLiked,
    required this.numberOfLikes,
    required this.isDisliked,
    required this.numberOfDislikes,
    required this.isBookmarked,
  });

  Post.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    String currentUserId,
    List<String> bookmarkedPostIds,
    Position? position,
  )   : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        ownerUserName = snapshot.data()[ownerUserNameFieldName] as String,
        ownerProfilePicUrl =
            snapshot.data()[ownerProfilePictureFieldName] as String?,
        title = snapshot.data()[titleFieldName] as String,
        content = snapshot.data()[textFieldName] as String,
        imageUrl = snapshot.data()[imageLinkFieldName] as String?,
        contact = snapshot.data()[contactFieldName] as String?,
        category = snapshot.data()[categoryFieldName] as String,
        latitude = snapshot.data()[latitudeFieldName] as double,
        longitude = snapshot.data()[longitudeFieldName] as double,
        distance = position == null
            ? null
            : Geolocator.distanceBetween(
                snapshot.data()[latitudeFieldName],
                snapshot.data()[longitudeFieldName],
                position.latitude,
                position.longitude,
              ).toInt(),
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
    return getDateFromNowText(postedDate);
  }
}
