import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:utility/util/custom_container.dart';

class ClosedSlider extends StatefulWidget {
  final SheetState state;
  final SheetController controller;

  ClosedSlider(this.state, this.controller, {Key key}) : super(key: key);

  @override
  ClosedSliderState createState() => ClosedSliderState();
}

class ClosedSliderState extends State<ClosedSlider> {
  static const textStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'sans-serif-medium',
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    Widget button(
      Icon icon,
      Text text,
      VoidCallback onTap, {
      BorderSide border,
      Color color,
    }) {
      final child = Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //icon,
          const SizedBox(width: 8),
          text,
        ],
      );

      const shape = RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(18)),
      );

      return border == null
          ? RaisedButton(
              color: color,
              onPressed: onTap,
              elevation: 2,
              shape: shape,
              child: child,
            )
          : OutlineButton(
              color: color,
              onPressed: onTap,
              borderSide: border,
              shape: shape,
              child: child,
            );
    }

    return CustomContainer(
      shadowDirection: ShadowDirection.top,
      padding: EdgeInsets.only(
        //TODO CHECK HOW TO CENTER THE BUTTON
        left: (MediaQuery.of(context).size.width / 2) - 80,
        top: 8,
      ),
      color: Colors.white,
      shadowColor: Colors.black12,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 8),
          SheetListenerBuilder(
            buildWhen: (oldState, newState) =>
                oldState.isExpanded != newState.isExpanded,
            builder: (context, state) {
              final isExpanded = state.isExpanded;
              //color: mapsBlue,
              return button(
                  //TODO TO REMOVE, IT'S NOT DISPLAYED BECAUSE OF THE COMMENT IN THE BUTTON SECTION
                  Icon(
                    !isExpanded ? Icons.list : Icons.map,
                    //color: mapsBlue,
                  ),
                  Text(
                    !isExpanded ? 'Scopri di più' : 'Mostra la mappa',
                    style: textStyle.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  !isExpanded
                      ? () => widget.controller.scrollTo(state.maxScrollExtent)
                      : widget.controller.collapse,
                  color: Colors.white,
                  // Remove border on button
                  border: BorderSide.none
                  /*border: BorderSide(
                  color: Colors.grey.shade400,
                  width: 2,
                ),*/
                  );
            },
          ),
        ],
      ),
    );
  }
}
