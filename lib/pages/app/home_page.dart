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
  late final GoogleMapController _mapController;
  late final LocationProvider _locationService;
  Position? currentLocation;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(37.42, -122.05), zoom: 14);
  Set<Marker> markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    // await _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    currentLocation = await _locationService.getCurrentLocation();
    setState(() {
      markers.add(Marker(
        markerId: const MarkerId('userLocation'),
        position: LatLng(currentLocation!.latitude, currentLocation!.longitude),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ));
    });
  }

  @override
  void initState() {
    _locationService = LocationProvider();
    _locationService.liveLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            currentLocation = await _locationService.getCurrentLocation();
            _mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                    zoom: 14)));
            markers.clear();
            markers.add(Marker(
                markerId: const MarkerId('Current Location'),
                position: LatLng(
                    currentLocation!.latitude, currentLocation!.longitude)));
          },
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 500,
              floating: false,
              pinned: false,
              flexibleSpace: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
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
        ),
      ),
    );
  }
}
