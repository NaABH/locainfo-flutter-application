import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMap extends StatelessWidget {
  final double lat;
  final double lon;
  const MyGoogleMap({Key? key, required this.lat, required this.lon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      padding: const EdgeInsets.only(bottom: 10),
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lon),
        zoom: 14.0,
      ),
      markers: {
        Marker(markerId: const MarkerId('Source'), position: LatLng(lat, lon))
      },
    );
  }
}
