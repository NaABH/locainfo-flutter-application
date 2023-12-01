import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:locainfo/services/firestore/database_constants.dart';

// class to store store value retrieve from the fireStore
@immutable
class CurrentUser {
  final String userId;
  final String userName;
  final String userEmail;
  final String? profilePicLink;

  const CurrentUser({
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.profilePicLink,
  });

  static CurrentUser fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    return CurrentUser(
      userId: snapshot.id,
      userName: data?[usernameFieldName] as String,
      userEmail: data?[emailAddressFieldName] as String,
      profilePicLink: data?[profilePictureFieldName] as String?,
    );
  }
}
