import 'package:flutter/material.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_post_bottombar.dart';
import 'package:locainfo/components/mytag.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  final List<String> bookmarksId;
  const PostDetailPage({
    super.key,
    required this.post,
    required this.bookmarksId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: ListView(padding: EdgeInsets.zero, children: [
          post.imageUrl != null
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    image: DecorationImage(
                        image: NetworkImage(post.imageUrl!), fit: BoxFit.cover),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: MyTag(
                              backgroundColor: Colors.grey.withAlpha(150),
                              children: [
                                Text(
                                  categories[post.category]!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: MyTag(
                        backgroundColor: Colors.grey.withAlpha(150),
                        children: [
                          Text(
                            categories[post.category]!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                  ),
                ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
                Text(
                  'Posted by ${post.ownerUserName}, ${post.timeAgo}',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                Text(
                  'At ${post.locationName}',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  post.text,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await _launchMaps();
                  },
                  child: MyTag(
                    backgroundColor: AppColors.grey3,
                    children: const [
                      Icon(
                        Icons.directions,
                        size: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text('Bring me there'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
        bottomNavigationBar: MyPostBottomBar(
          post: post,
          isBookmarked: bookmarksId.contains(post.documentId),
        ),
      ),
    );
  }

  Future<void> _launchMaps() async {
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${post.latitude},${post.longitude}";
    Uri mapUrl = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(mapUrl)) {
      await launchUrl(mapUrl);
    } else {
      throw 'Could not launch Google Map now';
    }
  }
}
