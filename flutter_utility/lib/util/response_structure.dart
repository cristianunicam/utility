import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Response {
  final String id;
  final String caiSection;
  final String difficulty;
  final String time;
  final String km;
  final String ascent;
  final String downloadLink;
  final Polyline polylineResult;

  Response({
    this.id,
    this.caiSection,
    this.difficulty,
    this.time,
    this.km,
    this.ascent,
    this.downloadLink,
    this.polylineResult,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    // Take the route object from the json
    Map<String, dynamic> route = json['route'];
    debugPrint(route.toString());
    List<dynamic> gpx = json['gpx']['tracks'][0]['segments'][0];

    // Begin polyline part
    List<LatLng> routeCoords = [];

    gpx.forEach((element) {
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

    return Response(
      id: route['id'],
      caiSection: route['cai_section'],
      difficulty: route['difficulty'],
      time: route['time'],
      km: route['km'],
      ascent: route['ascent'],
      downloadLink: route['download_link'],
      polylineResult: routePolyline,
    );
  }
}
