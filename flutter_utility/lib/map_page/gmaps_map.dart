import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:utility/util/response_structure.dart';

import 'gmaps_marker.dart';

class MapPage extends StatefulWidget {
  final Future<Response> response;

  MapPage({Key key, this.response}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Set<Marker> _markerSet = Set<Marker>();
  Set<Polyline> _routePolyline = Set<Polyline>();
  Position _currentPosition;
  GoogleMapController _controller;
  bool isMapCreated = false;
  Future<Response> futureResponse;

  @override
  void initState() {
    super.initState();
    futureResponse = widget.response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _buildLocationButton(context),
        ],
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    debugPrint("MAP");
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentPosition != null
              ? LatLng(_currentPosition.latitude, _currentPosition.longitude)
              : LatLng(43.295329, 13.447757),
          zoom: 12,
        ),
        polylines: _routePolyline,
        onMapCreated: (GoogleMapController controller) =>
            _onMapCreated(controller),
        markers: _markerSet,
      ),
    );
  }

  changeMapMode() {
    getJsonFile("assets/map_theme/grey_theme.json").then(
      (mapStyle) => _controller.setMapStyle(mapStyle),
    );
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  _buildLocationButton(context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 0, 0, MediaQuery.of(context).padding.bottom + 16),
        child: ClipOval(
          child: Material(
            color: Colors.white, // button color
            child: InkWell(
              splashColor: Colors.blue, // inkwell color
              child: SizedBox(
                width: 56,
                height: 56,
                child: Icon(Icons.my_location),
              ),
              onTap: () {
                _goToCurrentLocation();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToLocation(double lat, double long) async {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 15,
          tilt: 0,
          bearing: 0,
        ),
      ),
    );
  }

  _goToCurrentLocation() async {
    await getCurrentPosition().then((Position position) {
      //setState(() {
      _currentPosition = position;
      _goToLocation(_currentPosition.latitude, _currentPosition.longitude);
      // });
    }).catchError((e) => print(e));
  }

  _onMapCreated(GoogleMapController controller) {
    double startLatitude, startLongitude;
    _controller = controller;
    //isMapCreated = true;
    changeMapMode();
    futureResponse.then((value) => {
          // Draw the route
          _routePolyline.clear(),
          _routePolyline.add(value.polylineResult),
          startLatitude = value.polylineResult.points.first.latitude,
          startLongitude = value.polylineResult.points.first.longitude,

          // Start waypoint
          _markerSet.add(
            new GMapsMarker().buildMarker(
                "start", "Inizio percorso", startLatitude, startLongitude),
          ),
          // End waypoint
          _markerSet.add(
            GMapsMarker().buildMarker(
              "end",
              "Fine percorso",
              value.polylineResult.points.last.latitude,
              value.polylineResult.points.last.longitude,
            ),
          ),

          _goToLocation(startLatitude, startLongitude),
        });
  }
}
