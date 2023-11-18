import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/routes.dart';
import 'package:locainfo/pages/create_account_page.dart';
import 'package:locainfo/pages/email_verification_page.dart';
import 'package:locainfo/pages/forgot_password_page.dart';
import 'package:locainfo/pages/home_page.dart';
import 'package:locainfo/pages/login_page.dart';
import 'package:locainfo/pages/onBoarding_page.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/bloc/auth_state.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocaInfo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.main_blue),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const MainPage(),
      ),
      routes: {
        onBoardingPageRoute: (context) => const OnBoardingPage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
          return const HomePage();
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
