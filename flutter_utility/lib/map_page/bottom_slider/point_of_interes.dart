import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class PointOfInterest extends StatefulWidget {
  final double latitude, longitude;

  PointOfInterest({Key key, this.latitude, this.longitude}) : super(key: key);

  @override
  _PointOfInterestState createState() => _PointOfInterestState();
}

class _PointOfInterestState extends State<PointOfInterest> {
  GoogleMapsPlaces _places = GoogleMapsPlaces();
  List<PlacesSearchResult> places = [];
  double latitude, longitude;

  @override
  void initState() {
    super.initState();
    latitude = widget.latitude;
    longitude = widget.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<List<Marker>> getList() async {
    GoogleMapsPlaces _places = GoogleMapsPlaces();
    List<PlacesSearchResult> places = [];
    double latitude, longitude;
    List<Marker> markerList = [];

    final location = Location(latitude, longitude);
    final placesSearchResponse =
        await _places.searchNearbyWithRadius(location, 2500);

    //this.isLoading = false;
    if (placesSearchResponse.status == "OK") {
      this.places = placesSearchResponse.results;
      placesSearchResponse.results.forEach((f) {
        markerList.add(
          Marker(
            position: LatLng(f.geometry.location.lat, f.geometry.location.lng),
            infoWindow: InfoWindow(title: "${f.name}" + "${f.types?.first}"),
          ),
        );
        // mapController.(markerOptions);
      });
      return markerList;
    } else {
      return null;
      //this.errorMessage = placesSearchResponse.errorMessage;
    }
  }
}
