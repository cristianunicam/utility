import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:utility/map_page/gmaps_map.dart';
import 'package:utility/models/response_structure.dart';

/**
 * Build the map and top right bottom
 */
class BuildClosedSliderPage extends StatefulWidget {
  static const mapsBlue = Color(0xFF4185F3);
  final Future<ResponseWithGPX> response;
  final Function(List<Marker>) callbackMarkers;
  final Function(GoogleMapController) callbackController;

  BuildClosedSliderPage(
      {Key key, this.response, this.callbackMarkers, this.callbackController})
      : super(key: key);

  @override
  _BuildClosedSliderPageState createState() => _BuildClosedSliderPageState();
}

class _BuildClosedSliderPageState extends State<BuildClosedSliderPage> {
  Future<ResponseWithGPX> futureResponse;
  GoogleMapController mapController;
  bool isMapCreated = false;
  PlacesSearchResponse placesResponse;

  @override
  void initState() {
    super.initState();
    futureResponse = widget.response;
  }

  @override
  Widget build(BuildContext context) {
    // Execute the request given an id
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 70),
          child: MapPage(
            response: futureResponse,
            callbackMarkers: widget.callbackMarkers,
            callbackController: widget.callbackController,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).padding.top + 16, 16, 0),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                /*TODO DO SOMETHING, LET THE USER CHOOSE THE KIND OF MAP
                  HE WOULD LIKE TO USE (NOT THE STYLE)
                await showBottomSheetDialog(context);*/
              },
              child: const Icon(
                Icons.layers,
                color: BuildClosedSliderPage.mapsBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
