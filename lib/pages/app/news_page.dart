import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  late Position _currentLocation;
  String get userId =>
      FirebaseAuthProvider().currentUser!.id; // get current user id

  Future<void> _refreshData() async {
    setState(() {
      // This will trigger the StreamBuilder to rebuild and re-fetch the posts
      _getCurrentLocation();
    });
  }

  @override
  void initState() {
    _databaseService = FireStoreProvider();
    _getCurrentLocation();
    super.initState();
  }

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = position;
      });
    } catch (e) {
      print(e);
    }
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
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: StreamBuilder(
            // stream: _databaseService.allPosts(ownerUserId: userId),
            stream: _databaseService.getNearbyPosts(
                userLat: _currentLocation!.latitude,
                userLng: _currentLocation!.longitude),
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
                    return const Center(child: CircularProgressIndicator());
                  }
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}
