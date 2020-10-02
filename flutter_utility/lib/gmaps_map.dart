import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  GoogleMapController _controller;
  bool isMapCreated = false;

  @override
  void initState() {
    super.initState();
  }

  double zoomVal = 5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          //_zoomMinusFunction(),
          //_zoomPlusFunction(),
        ],
      ),
    );
  }

/*
  Widget _zoomMinusFunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(
            FontAwesomeIcons.searchMinus,
            color: Color(0xff6200ee),
          ),
          onPressed: () {
            zoomVal--;
            _minus(zoomVal);
          }),
    );
  }

  Widget _zoomPlusFunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchPlus, color: Color(0xff6200ee)),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }
*/
  changeMapMode() {
    getJsonFile("assets/map_theme/grey_theme.json").then(setMapStyle);
    //TODO YOU COULD CHANGE WITH A DIFFERENT STYLE
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  Widget _buildGoogleMap(BuildContext context) {
    /*    //TODO YOU COULD CHANGE WITH A DIFFERENT STYLE
    if (isMapCreated) {
      changeMapMode();
    }*/
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(40.712776, -74.005974),
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          //TODO YOU COULD CHANGE WITH A DIFFERENT STYLEisMapCreated = true;
          changeMapMode();
          setState(() {});
        },
        markers: {
          /*newyork1Marker,
          newyork2Marker,
          newyork3Marker,
          gramercyMarker,
          bernardinMarker,
          blueMarker*/
        },
      ),
    );
  }

  Future<void> _goToLocation(double lat, double long) async {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}
