import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMapsMarker {
  Marker buildMarker(
    final String id,
    final String name,
    final double latitude,
    final double longitude,
  ) {
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: name),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueViolet,
      ),
    );
  }
}
