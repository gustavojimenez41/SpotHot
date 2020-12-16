import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapsPage extends StatelessWidget {
  static const id = "maps_page";
  @override
  Widget build(BuildContext context) {
    return MapSample();
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition yourLocation = CameraPosition(
    target: LatLng(37.77483, -122.41942),
    zoom: 13,
  );

  void bleh() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawerScrimColor: Color(0xFFFFBE8F),
      body: GoogleMap(
        initialCameraPosition: yourLocation,
        // onMapCreated: (GoogleMapController controller) {
        //   _controller.complete(controller);
        // },
      ),
    );
  }
}
