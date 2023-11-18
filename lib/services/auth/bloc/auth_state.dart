import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:locainfo/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading; // isLoading
  final String? loadingText; // to display loading text
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Loading...', // default message
  });
}

// before everything
class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

// user is logged out
// this class is comparable
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception; // hold exception
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}

// user registering
class AuthStateRegistering extends AuthState {
  final Exception? exception; // prepare to hold an exception if occur
  const AuthStateRegistering({
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);
}

// user logging in
class AuthStateLoggingIn extends AuthState {
  final Exception? exception; // prepare to hold an exception if occur
  const AuthStateLoggingIn({
    required this.exception,
    required isLoading,
    String? loadingText,
  }) : super(isLoading: isLoading);
}

// user forget password
class AuthStateForgotPassword extends AuthState {
  final Exception? exception; // hold exception
  final bool hasSentEmail; // has send password reset email?
  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

// user want to login
class AuthStateLoggedIn extends AuthState {
  final AuthUser user; // carry a user
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

// user need to verify their account
class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}
