import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id; // user id
  final String email; // user email
  final bool isEmailVerified; // user email verified

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  // factory constructor that extract info from firebase user to create an authuser instance
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
