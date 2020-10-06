import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:utility/map_page/gmaps_map.dart';
import 'package:utility/util/htpp_request.dart';
import 'package:utility/util/response_structure.dart';

/**
 * Build the map and top right bottom
 */
class BuildClosedSliderPage extends StatefulWidget {
  static const mapsBlue = Color(0xFF4185F3);
  Future<Response> response;

  BuildClosedSliderPage({Key key, this.response}) : super(key: key);

  @override
  _BuildClosedSliderPageState createState() => _BuildClosedSliderPageState();
}

class _BuildClosedSliderPageState extends State<BuildClosedSliderPage> {
  Future<Response> futureResponse;

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
