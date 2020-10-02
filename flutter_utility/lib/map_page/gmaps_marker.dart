import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMapsMarker extends StatelessWidget {
  // Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(40.712776, -74.005974), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          //_controller.complete(controller);
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
}
