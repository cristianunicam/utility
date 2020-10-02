import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../bottom_slider/slider_closed.dart';
import '../bottom_slider/slider_footer.dart';
import '../bottom_slider/slider_header.dart';
import '../bottom_slider/slider_opened.dart';

class AppStructure extends StatefulWidget {
  @override
  AppStructureState createState() => AppStructureState();
}

/**
 * Build the structure of the slider
 */
class AppStructureState extends State<AppStructure> {
  ValueNotifier<SheetState> sheetState = ValueNotifier(SheetState.inital());
  SheetState get state => sheetState.value;
  set state(SheetState value) => sheetState.value = value;

  SheetController controller;
  bool tapped = false;

  @override
  void initState() {
    super.initState();
    controller = SheetController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => setState(() => tapped = !tapped),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: tapped ? 200 : 0,
              color: Colors.red,
            ),
          ),
          Expanded(
            // child: BuildSlider(controller),
            // Set the slider layout
            child: SlidingSheet(
              duration: const Duration(milliseconds: 900),
              controller: controller,
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
              // Build the map and the top right button
              body: BuildClosedSliderPage(),
              // Build the slider header
              headerBuilder: (context, state) {
                return SliderHeader(state);
              },
              // Build the closed slider
              footerBuilder: (context, state) {
                return ClosedSlider(state, controller);
              },
              // Build the opened slider
              builder: (context, state) {
                return OpenedSlider();
              },
            ),
          ),
        ],
      ),
    );
  }
}