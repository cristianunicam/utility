import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:utility/map_page/gmaps_map.dart';

/**
 * Build the map and top right bottom
 */
class BuildClosedSliderPage extends StatelessWidget {
  static const mapsBlue = Color(0xFF4185F3);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 70),
          child: MapPage(),
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
                color: mapsBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
