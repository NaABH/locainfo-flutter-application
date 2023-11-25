// abstract class AuthEvent
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class DatabaseEvent {
  const DatabaseEvent();
}

class DatabaseEventLoadNewsPagePost extends DatabaseEvent {
  const DatabaseEventLoadNewsPagePost();
}

class DatabaseEventCreatePost extends DatabaseEvent {
  final String ownerUserId;
  final String ownerUserName;
  final String title;
  final String body;
  final String category;
  final double latitude;
  final double longitude;
  final Timestamp postedDate;
  const DatabaseEventCreatePost(
      this.ownerUserId,
      this.ownerUserName,
      this.title,
      this.body,
      this.category,
      this.latitude,
      this.longitude,
      this.postedDate);
}
