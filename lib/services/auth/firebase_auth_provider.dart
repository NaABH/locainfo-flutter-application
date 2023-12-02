import 'package:firebase_auth/firebase_auth.dart'
    show
        FirebaseAuth,
        FirebaseAuthException,
        GoogleAuthProvider,
        UserCredential;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locainfo/services/auth/auth_exceptions.dart';
import 'package:locainfo/services/auth/auth_provider.dart';
import 'package:locainfo/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  // implement FireStoreProvider as a singleton
  static final FirebaseAuthProvider _shared =
      FirebaseAuthProvider._sharedInstance();
  FirebaseAuthProvider._sharedInstance();
  factory FirebaseAuthProvider() => _shared;

  // return Future<AuthUser>
  @override
  Future<AuthUser> createUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // create new user account
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        await userCredential.user!.updateDisplayName(username);
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  String? get currentUserName {
    final username = FirebaseAuth.instance.currentUser?.displayName;
    if (username != null) {
      return username;
    } else {
      return null;
    }
  }

  @override
  String? get currentUserProfilePicUrl {
    final username = FirebaseAuth.instance.currentUser?.photoURL;
    if (username != null) {
      return username;
    } else {
      return null;
    }
  }

  @override
  Future<void> updateProfilePicUrl(String imageUrl) async {
    FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
  }

  @override
  Future<void> updateDisplayName(String newName) async {
    FirebaseAuth.instance.currentUser?.updateDisplayName(newName);
  }

  // return Future<AuthUser>
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFoundAuthException();
          break;
        case 'wrong-password':
          throw WrongPasswordAuthException();
          break;
        case 'invalid-email':
          throw InvalidEmailAuthException();
          break;
        case 'user-disabled':
          throw AccountDisabledAuthException();
          break;
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> signInGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on Exception catch (_) {
      throw CouldNotSignInWithGoogleException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
