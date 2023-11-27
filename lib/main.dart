import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/routes.dart';
import 'package:locainfo/pages/app/create_post_page.dart';
import 'package:locainfo/pages/app/post_list_page.dart';
import 'package:locainfo/pages/main_login_page.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/location/location_provider.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthBloc>(
      create: (BuildContext context) => AuthBloc(FirebaseAuthProvider()),
    ),
    BlocProvider<MainBloc>(
      create: (BuildContext context) => MainBloc(),
    ),
    // BlocProvider<LocationBloc>(
    //   create: (BuildContext context) => LocationBloc(LocationProvider()),
    // ),
    // BlocProvider<DatabaseBloc>(
    //     create: (BuildContext context) => DatabaseBloc(
    //         FireStoreProvider(), LocationBloc(LocationProvider()))),
    BlocProvider<PostBloc>(
        create: (BuildContext context) => PostBloc(
            FireStoreProvider(), LocationProvider(), FirebaseAuthProvider()))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocaInfo',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const MainLoginPage(),
      routes: {
        createPostRoute: (context) => const CreatePostPage(),
        searchPostRoute: (context) => PostListPage(),
      },
    );
  }
}
