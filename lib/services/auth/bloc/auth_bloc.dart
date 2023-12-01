import 'package:bloc/bloc.dart';
import 'package:locainfo/services/auth/auth_exceptions.dart';
import 'package:locainfo/services/auth/auth_provider.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/bloc/auth_state.dart';
import 'package:locainfo/services/firestore/database_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider authProvider;
  final DatabaseProvider databaseProvider;
  AuthBloc(
    this.authProvider,
    this.databaseProvider,
  ) : super(const AuthStateUninitialized(isLoading: true)) {
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      final user = authProvider.currentUser;
      if (user == null) {
        // user not logged in
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
        // user registered but have not verified email
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        // user logged in
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });

    // direct user to create account page
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });

    // direct user to login page
    on<AuthEventShouldLogIn>((event, emit) async {
      emit(const AuthStateLoggingIn(
        exception: null,
        isLoading: false,
      ));
    });

    // user forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return; // user just wants to go to forgot password screen
      }
      // user wants to actually send a forget-password email
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      bool didSendEmail;
      Exception? exception;
      try {
        await authProvider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false,
      ));
    });

    // register event
    on<AuthEventRegister>((event, emit) async {
      final username = event.username;
      final email = event.email;
      final password = event.password;
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: true,
      ));
      try {
        if (username.trim().isEmpty ||
            RegExp(r'^[0-9\W_]').hasMatch(username)) {
          emit(AuthStateRegistering(
            exception: InvalidUsernameAuthException(),
            isLoading: false,
          ));
        } else {
          await authProvider.createUser(
            username: username,
            email: email,
            password: password,
          );
          await databaseProvider.createNewUser(
            userId: authProvider.currentUser!.id,
            username: username,
            emailAddress: email,
          );
          await authProvider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          // same state but with exception
          exception: e,
          isLoading: false,
        ));
      }
    });

    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await authProvider.sendEmailVerification();
      emit(state);
    });

    // log in event
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggingIn(
            exception: null, isLoading: true, loadingText: 'Logging in...'),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await authProvider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          // user  have not verify email
          emit(
            const AuthStateLoggingIn(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(
            const AuthStateLoggingIn(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggingIn(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    on<AuthEventSignInWithGoogle>((event, emit) async {
      emit(const AuthStateLoggingInWithGoogle(
        exception: null,
        isLoading: true,
        loadingText: 'Signing in with Google',
      ));
      try {
        final user = await authProvider.signInGoogle();
        await databaseProvider.createNewUser(
          userId: authProvider.currentUser!.id,
          username: user.displayName == null ? "Anonymous" : user.displayName!,
          emailAddress: authProvider.currentUser!.email,
        );
        if (user.isEmailVerified) {
          emit(const AuthStateLoggingInWithGoogle(
              exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        } else {
          emit(const AuthStateLoggingInWithGoogle(
              exception: null, isLoading: false));
          await authProvider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggingInWithGoogle(exception: e, isLoading: false));
      }
    });

    // log out event
    on<AuthEventLogOut>((event, emit) async {
      try {
        await authProvider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
  }
}
