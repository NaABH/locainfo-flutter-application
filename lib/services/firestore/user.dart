import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:locainfo/services/firestore/database_constants.dart';

@immutable
class AppUser {
  final String userId;
  final String username;
  final String userEmail;
  final String? profilePicLink;

  const AppUser({
    required this.userId,
    required this.username,
    required this.userEmail,
    this.profilePicLink,
  });

  static AppUser fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    return AppUser(
      userId: snapshot.id,
      username: data?[usernameFieldName] as String,
      userEmail: data?[emailAddressFieldName] as String,
      profilePicLink: data?[profilePictureFieldName] as String?,
    );
  }
}
