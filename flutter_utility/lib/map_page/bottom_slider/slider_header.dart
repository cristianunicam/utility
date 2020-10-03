import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:utility/util/custom_container.dart';
import 'package:utility/util/util.dart';

class SliderHeader extends StatefulWidget {
  final SheetState state;

  SliderHeader(this.state, {Key key}) : super(key: key);
  @override
  SliderHeaderState createState() => SliderHeaderState();
}

/**
 * Takes care of building the header of the slider
 */
class SliderHeaderState extends State<SliderHeader> {
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shadowColor: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Build the grey line for scrolling the slider
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.topCenter,
            child: CustomContainer(
              width: 120,
              height: 4,
              borderRadius: 2,
              color: Colors.grey.withOpacity(
                  .5 * (1 - interval(0.7, 1.0, widget.state.progress))),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
