import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:utility/bottom_slider/slider_header.dart';
import 'package:utility/bottom_slider/slider_opened.dart';

import 'slider_closed.dart';
import 'slider_footer.dart';

class BuildSlider extends StatefulWidget {
  final SheetController controller;

  BuildSlider(this.controller, {Key key}) : super(key: key);
  @override
  BuildSliderState createState() => BuildSliderState();
}

/**
 * Takes care of building the structure of the slider
 */
@Deprecated("Use map_page/structure.dart")
class BuildSliderState extends State<BuildSlider> {
  @override
  Widget build(BuildContext context) {
    return SlidingSheet(
      duration: const Duration(milliseconds: 900),
      controller: widget.controller,
      color: Colors.white,
      shadowColor: Colors.black26,
      elevation: 12,
      maxWidth: 500,
      cornerRadius: 16,
      cornerRadiusOnFullscreen: 0.0,
      closeOnBackdropTap: true,
      closeOnBackButtonPressed: true,
      addTopViewPaddingOnFullscreen: true,
      isBackdropInteractable: true,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 3,
      ),
      snapSpec: SnapSpec(
        snap: true,
        positioning: SnapPositioning.relativeToAvailableSpace,
        snappings: const [
          SnapSpec.headerFooterSnap,
          0.6,
          SnapSpec.expanded,
        ],
        onSnap: (state, snap) {
          print('Snapped to $snap');
        },
      ),
      parallaxSpec: const ParallaxSpec(
        enabled: true,
        amount: 0.35,
        endExtent: 0.6,
      ),
      liftOnScrollHeaderElevation: 12.0,
      liftOnScrollFooterElevation: 12.0,
      body: BuildClosedSliderPage(),
      headerBuilder: (context, state) {
        return SliderHeader(state);
      },
      footerBuilder: (context, state) {
        return ClosedSlider(state, widget.controller);
      },
      builder: (context, state) {
        return OpenedSlider();
      },
    );
  }
}
