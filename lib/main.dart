import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/routes.dart';
import 'package:locainfo/pages/auth/create_account_page.dart';
import 'package:locainfo/pages/auth/email_verification_page.dart';
import 'package:locainfo/pages/auth/forgot_password_page.dart';
import 'package:locainfo/pages/auth/login_page.dart';
import 'package:locainfo/pages/auth/onBoarding_page.dart';
import 'package:locainfo/pages/bookmark_page.dart';
import 'package:locainfo/pages/home_page.dart';
import 'package:locainfo/pages/news_page.dart';
import 'package:locainfo/pages/profile_page.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/bloc/auth_state.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/location/bloc/location_bloc.dart';
import 'package:locainfo/services/location/location_provider.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/main_event.dart';
import 'package:locainfo/services/main_state.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthBloc>(
      create: (BuildContext context) => AuthBloc(FirebaseAuthProvider()),
    ),
    BlocProvider<MainBloc>(
      create: (BuildContext context) => MainBloc(),
    ),
    BlocProvider<LocationBloc>(
      create: (BuildContext context) => LocationBloc(LocationProvider()),
    ),
  ], child: const MyApp()));
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
      home: const LoginInterface(),
      routes: {
        onBoardingPageRoute: (context) => const OnBoardingPage(),
      },
    );
  }
}

class LoginInterface extends StatelessWidget {
  const LoginInterface({super.key});

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
          return const MainInterface();
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

class MainInterface extends StatelessWidget {
  const MainInterface({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MainBloc>().add(const MainEventInitialise());
    return BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is MainStateHome) {
            return const HomePage();
          } else if (state is MainStateNews) {
            return const NewsPage();
          } else if (state is MainStateBookmark) {
            return const BookMarkPage();
          } else if (state is MainStateProfile) {
            return const ProfilePage();
          } else {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }
        });
  }
}
