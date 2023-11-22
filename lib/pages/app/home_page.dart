import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locainfo/components/my_post_list.dart';
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
  Set<Marker> markers = {}; // market on map
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

  @override
  void initState() {
    _locationService = LocationProvider();
    _databaseService = FireStoreProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              currentLocation = await _locationService.getCurrentLocation();
              _animateToLocation();
            },
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 500,
                floating: false,
                pinned: false,
                title: Container(
                  color: Colors.transparent,
                  height: 40,
                  width: 350,
                  child: SearchBar(),
                ),
                flexibleSpace: StreamBuilder<Position>(
                  stream: _locationService.getLocationStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      currentLocation = snapshot.data;
                      _animateToLocation();
                      return GoogleMap(
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
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0.0),
                  child: Container(
                    height: 15,
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
                  stream: _databaseService.allPosts(ownerUserId: userId),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allPosts = snapshot.data as Iterable<Post>;
                          if (allPosts.isEmpty) {
                            return const SliverFillRemaining(
                              child: Center(
                                child: Text(
                                  'Sorry. There is not post available for your current location.',
                                ),
                              ),
                            );
                          }
                          return MyPostList(
                            posts: allPosts,
                            onTap: (post) {},
                          );
                        } else {
                          return const SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      default:
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
