import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapSample();
  }
}

class MapSample extends StatefulWidget {
  MapSample();
  @override
  State createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController mapController;
  Location currentLocation = new Location();
  String url;

  //Getting the current location when user opens app
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    currentLocation.onLocationChanged.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );

      String currentLat = l.latitude.toString();
      String currentLon = l.longitude.toString();
      url =
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$currentLat,$currentLon&radius=1500&key=AIzaSyBUILBxCa5yyQZawAAOpD6HII48R3haimM";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition:
                CameraPosition(zoom: 15.0, target: LatLng(32.7297, -97.1129)),
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
          ),
        ],
      ),
    );
  }
}
