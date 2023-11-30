import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/pages/auth/create_account_page.dart';
import 'package:locainfo/pages/auth/email_verification_page.dart';
import 'package:locainfo/pages/auth/forgot_password_page.dart';
import 'package:locainfo/pages/auth/login_page.dart';
import 'package:locainfo/pages/auth/onBoarding_page.dart';
import 'package:locainfo/pages/main_app_page.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/bloc/auth_state.dart';
import 'package:locainfo/utilities/loading_screen/loading_screen.dart';

// class to control for whole authentication process
class MainLoginPage extends StatelessWidget {
  const MainLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // initialise event
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          // show loading screen
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Loading...',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          // go into the main app page that handle the in-app navigation
          return const MainAppPage();
        } else if (state is AuthStateLoggedOut) {
          // logout go onboarding page
          return const OnBoardingPage();
        } else if (state is AuthStateLoggingIn) {
          // login go login page
          return const LoginPage();
        } else if (state is AuthStateRegistering) {
          // register go create account page
          return const CreateAccountPage();
        } else if (state is AuthStateNeedsVerification) {
          // email verification go verify email page
          return const EmailVerificationPage();
        } else if (state is AuthStateForgotPassword) {
          // password reset go forgot password page
          return const ForgotPasswordPage();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
