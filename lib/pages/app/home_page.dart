import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locainfo/components/my_home_post_list.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/routes.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/location/location_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _mapController; // google map controller
  late final LocationProvider _locationService; // location provider
  Position? currentLocation; // current location
  Set<Marker> markers = {
    Marker(
      markerId: const MarkerId('Current Location'),
      position: LatLng(2.8727883, 101.4947),
    ),
  }; // market on map
  late final FireStoreProvider _databaseService;
  String get userId =>
      FirebaseAuthProvider().currentUser!.id; // get current user id

  // assign controller to map
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
  }

  void _updateMarkers() {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('Current Location'),
        position: LatLng(currentLocation!.latitude, currentLocation!.longitude),
      ),
    );
  }

  void _animateToLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
          zoom: 16,
        ),
      ),
    );
  }

  void _handleLocationStream(Position position) {
    setState(() {
      currentLocation = position;
      _animateToLocation();
    });
  }

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = position;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _locationService = LocationProvider();
    _getCurrentLocation();
    _databaseService = FireStoreProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 3 / 5,
            floating: false,
            pinned: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0), // Adjust this value as needed
              child: StreamBuilder<Position>(
                stream: _locationService.getLocationStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    currentLocation = snapshot.data;
                    _animateToLocation();
                    _getCurrentLocation();
                    return Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(currentLocation!.latitude,
                                  currentLocation!.longitude),
                              zoom: 16),
                          markers: markers,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          onMapCreated: _onMapCreated,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          padding: const EdgeInsets.only(bottom: 10),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, top: 10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(searchPostRoute);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.lighterBlue,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black38, blurRadius: 4)
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
                        Positioned(
                          top: 14,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: AppColors.lighterBlue,
                                    borderRadius: BorderRadius.circular(18)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.my_location,
                                      size: 20,
                                      color: AppColors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Current Location',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            bottom: PreferredSize(
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
          SliverFillRemaining(
            child: StreamBuilder(
              stream: currentLocation != null
                  ? _databaseService.getNearbyPostStream(
                      userLat: currentLocation!.latitude,
                      userLng: currentLocation!.longitude)
                  : null,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allPosts = snapshot.data as Iterable<Post>;
                      if (allPosts.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'Sorry. There is not post available for your current location.'),
                            ],
                          ),
                        );
                      }
                      return MyHomePostList(
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
          ),
        ],
      )),
    );
  }
}
