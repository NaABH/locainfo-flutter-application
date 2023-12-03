import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_post_bottombar.dart';
import 'package:locainfo/components/my_tag.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/utilities/toast_message.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;
  const PostDetailPage({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late FlutterTts _flutterTts;
  bool isPlaying = false;
  late Post currentPost;

  @override
  void initState() {
    currentPost = widget.post;
    _flutterTts = FlutterTts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              Navigator.pop(context, currentPost);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(
                isPlaying ? Icons.stop : Icons.volume_up,
                color: AppColors.darkerBlue,
              ),
              onPressed: () async {
                if (isPlaying) {
                  final result = await _flutterTts.stop();
                  if (result == 1) {
                    setState(() {
                      isPlaying = false;
                    });
                  }
                } else {
                  final result = await _flutterTts.speak(currentPost.content);
                  if (result == 1) {
                    setState(() {
                      isPlaying = true;
                    });
                  }
                }
              },
            ),
          ],
        ),
        body: ListView(padding: EdgeInsets.zero, children: [
          currentPost.imageUrl != null
              ? GestureDetector(
                  onTap: () {
                    final imageProvider =
                        Image.network(currentPost.imageUrl!).image;
                    showImageViewer(
                      context,
                      imageProvider,
                      swipeDismissible: true,
                      doubleTapZoomable: true,
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      image: DecorationImage(
                          image: NetworkImage(currentPost.imageUrl!),
                          fit: BoxFit.cover),
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
                                    postCategories[currentPost.category]!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child:
                        MyTag(backgroundColor: AppColors.darkerBlue, children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        postCategories[currentPost.category]!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
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
                  currentPost.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentPost.ownerProfilePicUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 18,
                            )
                          : CircleAvatar(
                              radius: 12,
                              backgroundImage:
                                  NetworkImage(currentPost.ownerProfilePicUrl!),
                            ),
                      const SizedBox(width: 8),
                      Text(
                        currentPost.ownerUserName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat('yyyy-MM-dd kk:mm').format(currentPost.postedDate),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                Text(
                  'At ${currentPost.locationName}',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  currentPost.content,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.grey4,
                        width: 1,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 1,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              currentPost.latitude, currentPost.longitude),
                          zoom: 16,
                        ),
                        zoomControlsEnabled: false,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        mapToolbarEnabled: false,
                        markers: <Marker>{
                          Marker(
                            markerId: MarkerId(currentPost.documentId),
                            position: LatLng(
                                currentPost.latitude, currentPost.longitude),
                          ),
                        },
                      ),
                    ),
                  ),
                ),
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
          post: currentPost,
          onUpdatePostState: (post) {
            setState(() {
              currentPost = post;
            });
          },
        ),
      ),
    );
  }

  Future<void> _launchMaps() async {
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${currentPost.latitude},${currentPost.longitude}";
    Uri mapUrl = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(mapUrl)) {
      await launchUrl(mapUrl);
    } else {
      showToastMessage('Could not launch Google Map now');
    }
  }
}
