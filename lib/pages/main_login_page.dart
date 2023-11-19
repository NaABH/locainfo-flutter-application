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

class MainLoginPage extends StatelessWidget {
  const MainLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // if (state.isLoading) {
        //   LoadingScreen().show(
        //     context: context,
        //     text: state.loadingText ?? 'Please wait a moment',
        //   );
        // } else {
        //   LoadingScreen().hide();
        // }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const MainAppPage();
        } else if (state is AuthStateLoggedOut) {
          // logout
          return const OnBoardingPage();
        } else if (state is AuthStateLoggingIn) {
          // login
          return const LoginPage();
        } else if (state is AuthStateRegistering) {
          // register
          return const CreateAccountPage();
        } else if (state is AuthStateNeedsVerification) {
          // email verification
          return const EmailVerificationPage();
        } else if (state is AuthStateForgotPassword) {
          // password reset
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
