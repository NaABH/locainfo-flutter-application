import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/routes.dart';
import 'package:locainfo/pages/forgot_password_page.dart';
import 'package:locainfo/pages/login_page.dart';
import 'package:locainfo/pages/onBoarding_page.dart';
import 'package:locainfo/pages/register_page.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/bloc/auth_state.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyTesting extends StatelessWidget {
  const MyTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Testing',
      home: HomePage(),
    );
  }
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
        child: const HomePage(),
      ),
      routes: {
        onBoardingPageRoute: (context) => const OnBoardingPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          return const Scaffold(
            body: Text('LoggedIn'),
          );
          // } else if (state is AuthStateNeedsVerification) {
          //   return const VerifyEmailView();
        } else if (state is AuthStateLoggingIn) {
          return const LoginPage();
        } else if (state is AuthStateLoggedOut) {
          return const OnBoardingPage();
        } else if (state is AuthStateRegistering) {
          return const RegisterPage();
        } else if (state is AuthStateForgotPassword) {
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
