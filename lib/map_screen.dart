import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.92280, 67.12513),
    zoom: 14.4746,
  );

  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(24.92280, 67.12513),
        infoWindow: InfoWindow(title: 'The title of the Marker'))
  ];

  Future<Position> getusercurrentlocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onTap: (LatLng latLng) {
          _markers.add(Marker(markerId: MarkerId('mark'), position: latLng));
          print(latLng);
          setState(() {});
        },
        markers: Set<Marker>.of(_markers),
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          getusercurrentlocation().then((value) async {
            print("my current location");
            print(value.latitude.toString() + " " + value.longitude.toString());
            _markers.add(Marker(
                markerId: MarkerId('1'),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: InfoWindow(title: 'The title of the Marker')));
            CameraPosition cameraposition = CameraPosition(
                zoom: 14, target: LatLng(value.latitude, value.longitude));
            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraposition));
            setState(() {});
          });
        },
        label: const Text('Current location'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }
}
