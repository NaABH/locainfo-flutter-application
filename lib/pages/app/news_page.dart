import 'package:flutter/material.dart';
import 'package:locainfo/components/my_post_list.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/firestore/post.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late final FireStoreProvider _databaseService;
  String get userId =>
      FirebaseAuthProvider().currentUser!.id; // get current user id

  @override
  void initState() {
    _databaseService = FireStoreProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              AppBarHeading(text: 'News'),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  color: AppColors.main_blue,
                  size: 26,
                )),
          ],
        ),
        body: StreamBuilder(
          stream: _databaseService.allPosts(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allPosts = snapshot.data as Iterable<Post>;
                  if (allPosts.isEmpty) {
                    return const Center(
                      child: Text(
                          'Sorry. There is not post available for your current location.'),
                    );
                  }
                  return MyPostList(
                    posts: allPosts,
                    onTap: (post) {},
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
