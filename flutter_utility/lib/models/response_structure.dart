import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ResponseWithGPX {
  final String id;
  final String caiSection;
  final String difficulty;
  final String time;
  final String km;
  final String ascent;
  final String downloadLink;
  final String description;
  final Polyline polylineResult;
  final List<double> elevationList;
  final List<LatLng> routePoints;

  ResponseWithGPX({
    this.id,
    this.caiSection,
    this.difficulty,
    this.time,
    this.km,
    this.ascent,
    this.downloadLink,
    this.description,
    this.polylineResult,
    this.elevationList,
    this.routePoints,
  });

  factory ResponseWithGPX.fromJson(Map<String, dynamic> json) {
    // Take the route object from the json
    Map<String, dynamic> route = json['route'];
    List<dynamic> gpx = json['gpx']['tracks'][0]['segments'][0];

    // Parse json
    List<LatLng> routeCoords = [];
    List<double> elevationList = [];

    gpx.forEach((element) {
      if (element['elevation'] > -1.0) {
        elevationList.add(element['elevation'].toDouble());
      }
      routeCoords.add(
        LatLng(
          element['lat'],
          element['lon'],
        ),
      );
    });

    Polyline routePolyline = new Polyline(
      polylineId: PolylineId("route"),
      geodesic: true,
      points: routeCoords,
      width: 20,
      color: Colors.black38,
    );

    return ResponseWithGPX(
      id: route['id'],
      caiSection: route['cai_section'],
      difficulty: route['difficulty'],
      time: route['time'],
      km: route['km'].toString().replaceAll('^', '.'),
      ascent: route['ascent'],
      downloadLink: route['download_link'],
      description: route['description'],
      polylineResult: routePolyline,
      elevationList: elevationList,
      routePoints: routeCoords,
    );
  }
}
