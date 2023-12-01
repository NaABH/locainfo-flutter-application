import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/routes.dart';
import 'package:locainfo/firebase_options.dart';
import 'package:locainfo/pages/app/create_post_page.dart';
import 'package:locainfo/pages/app/posted_posts_page.dart';
import 'package:locainfo/pages/app/searching_page.dart';
import 'package:locainfo/pages/main_login_page.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/cloud_storage/cloudstorage_provider.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/location/location_provider.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/post/post_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthBloc>(
      create: (BuildContext context) =>
          AuthBloc(FirebaseAuthProvider(), FireStoreProvider()),
    ),
    BlocProvider<MainBloc>(
      create: (BuildContext context) => MainBloc(),
    ),
    BlocProvider<PostBloc>(
        create: (BuildContext context) => PostBloc(FireStoreProvider(),
            LocationProvider(), FirebaseAuthProvider(), CloudStorageProvider()))
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
        searchPostRoute: (context) => const SearchingPage(),
        postedPostRoute: (context) => const PostedPostsPage(),
        // updateProfileRoute: (context) => const UpdateProfilePage(),
      },
    );
  }
}
