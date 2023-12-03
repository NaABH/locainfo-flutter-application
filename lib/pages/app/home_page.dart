import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locainfo/components/my_post.dart';
import 'package:locainfo/components/my_snackbar.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/constants/routes.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/location/bloc/location_bloc.dart';
import 'package:locainfo/services/location/bloc/location_event.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/main_state.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/loading_screen/animeated_loading_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _mapController; // google map controller
  late final ScrollController _scrollController;
  late Position currentPosition;
  late final String weatherInformation;
  final Map<String, int> _postIndices = {};
  Set<Marker> markers = {}; // market on map
  int pageShowPostLimit = 15;

  // assign controller to map
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
  }

  void _animateToLocation(Position currentPosition) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 16,
        ),
      ),
    );
  }

  // update the markers
  void updateMarkers(List<Post> posts) {
    markers.clear();
    _postIndices.clear();
    markers = Set.from(
      posts.asMap().entries.map((entry) {
        final post = entry.value;
        final index = entry.key;
        _postIndices[post.documentId] = index;
        final offset = Random().nextDouble() * 0.0001 - 0.00005;
        return Marker(
          markerId: MarkerId(post.documentId),
          position: LatLng(post.latitude + offset, post.longitude + offset),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
          infoWindow: InfoWindow(title: post.title),
          onTap: () {
            _scrollController.animateTo(
              _postIndices[post.documentId]! *
                  300, // Replace 56.0 with your ListTile height
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
            );
          },
        );
      }),
    );
  }

  @override
  void initState() {
    context.read<LocationBloc>().add(LocationEventStartTracking());
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ScaffoldMessenger.of(context)
            .showSnackBar(mySnackBar(message: 'Go News Page to view more...'));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    context.read<LocationBloc>().add(LocationEventStopTracking());
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 3 / 5,
              floating: false,
              pinned: false,
              flexibleSpace: Stack(
                children: [
                  BlocBuilder<LocationBloc, Position>(
                    builder: (context, position) {
                      currentPosition = position;
                      _animateToLocation(currentPosition);
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target:
                                LatLng(position.latitude, position.longitude),
                            zoom: 16),
                        markers: markers,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        mapType: MapType.normal,
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        padding: const EdgeInsets.only(bottom: 10),
                      );
                    },
                  ),
                  Padding(
                    // search button
                    padding: const EdgeInsets.only(right: 10, top: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(searchPostRoute);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.lighterBlue,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(color: Colors.black38, blurRadius: 4)
                              ],
                            ),
                            child: const Icon(
                              Icons.search,
                              size: 32,
                              color: AppColors.white,
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    // my location button
                    padding: const EdgeInsets.only(right: 10, top: 70),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          _animateToLocation(currentPosition);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.lighterBlue,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, blurRadius: 4)
                            ],
                          ),
                          child: const Icon(
                            Icons.my_location,
                            size: 32,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // weather information
                    top: 14,
                    left: 10,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.lighterBlue,
                              borderRadius: BorderRadius.circular(18)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: BlocBuilder<MainBloc, MainState>(
                              builder: (context, state) {
                            if (state is MainStateHome) {
                              return Text(
                                state.weatherInformation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                ),
                              );
                            } else {
                              return const Text(
                                'Unknown',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                // divider (curved)
                preferredSize: const Size.fromHeight(0.0),
                child: Container(
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostStateLoadingPosts) {
                  return SliverFillRemaining(
                    child: AnimatedLoadingScreen(
                      imagePath: 'assets/animated_icon/loading_gps.json',
                      text: 'Refreshing',
                      imageSize: MediaQuery.of(context).size.width / 10,
                    ),
                  );
                } else if (state is PostStatePostLoaded) {
                  final nearbyPosts = state.posts;
                  updateMarkers(nearbyPosts.toList());
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return MyPost(
                        post: nearbyPosts.elementAt(index),
                        currentPosition: state.currentPosition,
                        onTap: (post) {},
                        patternType: PostPatternType.home,
                      );
                    },
                        childCount: state.posts.length >= pageShowPostLimit
                            ? pageShowPostLimit
                            : state.posts.length),
                  );
                } else if (state is PostStateNoAvailablePost) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                          'Sorry. There is no post available for your current location'),
                    ),
                  );
                } else {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Some error occurred. \nPlease check your Internet connection and GPS service.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                context
                                    .read<PostBloc>()
                                    .add(const PostEventLoadNearbyPosts());
                              },
                              icon: const Icon(Icons.refresh)),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
