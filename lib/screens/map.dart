import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gmap_codelab/models/locations.dart' as models;
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  bool loading = true;
  final Map<String, Marker> markers = {};

  onMapCreated(GoogleMapController controller) async {
    this.mapController = controller;

    try {
      final url = 'https://about.google/static/data/locations.json';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final locations = models.Locations.fromJson(json.decode(response.body));
        for (final office in locations.offices) {
          this.markers[office.name] = Marker(
            markerId: MarkerId(office.name),
            position: LatLng(office.lat, office.lng),
            infoWindow: InfoWindow(
              title: office.name,
              snippet: office.address,
            ),
          );
        }
      } else {
        this.showError();
      }
    } catch (e) {
      this.showError();
    }

    this.loading = false;
    setState(() {});
  }

  showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Unable to fetch data"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MapScreen"),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: GoogleMap(
              markers: this.markers.values.toSet(),
              onMapCreated: this.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 11.0,
              ),
            ),
          ),
          if (this.loading)
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black),
                backgroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
