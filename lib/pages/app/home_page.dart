import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locainfo/services/location/location_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GoogleMapController _mapController; // google map controller
  late final LocationProvider _locationService; // location provider
  Position? currentLocation; // current location
  Set<Marker> markers = {}; // market on map

  // assign controller to map
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    currentLocation = await _locationService.getCurrentLocation();
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
    _mapController.animateCamera(
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
    _locationService.startLocationStream(_handleLocationStream);
    super.initState();
  }

  @override
  void dispose() {
    _locationService.stopLocationStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (currentLocation == null) {
      child = const Center(child: CircularProgressIndicator());
    } else {
      child = CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500,
            floating: false,
            pinned: false,
            flexibleSpace: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude, currentLocation!.longitude)),
              markers: markers,
              zoomControlsEnabled: false,
              mapType: MapType.terrain,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              padding: const EdgeInsets.only(bottom: 10),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                height: 15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
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
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 200,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 200,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 200,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 200,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              _mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(currentLocation!.latitude,
                          currentLocation!.longitude),
                      zoom: 16)));
            },
          ),
          body: child),
    );
  }
}
