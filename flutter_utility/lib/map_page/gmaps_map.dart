import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Position _currentPosition;
  GoogleMapController _controller;
  bool isMapCreated = false;
  double zoomVal = 5.0;

  @override
  void initState() {
    super.initState();
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
          target: _currentPosition != null
              ? LatLng(_currentPosition.latitude, _currentPosition.longitude)
              : {
                  _getCurrentLocation(),
                  LatLng(_currentPosition.latitude, _currentPosition.longitude)
                },
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
                _getCurrentLocation();
                _goToLocation(
                  _currentPosition.latitude,
                  _currentPosition.longitude,
                );
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
          bearing: 45.0,
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    await getCurrentPosition().then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) => print(e));
  }
}
