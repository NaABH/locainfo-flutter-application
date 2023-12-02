import 'package:locainfo/services/auth/auth_user.dart';

abstract class AuthProvider {
  // get currently authenticated user
  // if null means there is no authenticated user
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  String? get currentUserName;
  Future<void> updateDisplayName(String newName);
  String? get currentUserProfilePicUrl;
  Future<void> updateProfilePicUrl(String imageUrl);

  Future<AuthUser> createUser({
    required String username,
    required String email,
    required String password,
  });

  Future<AuthUser> signInGoogle();
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}
