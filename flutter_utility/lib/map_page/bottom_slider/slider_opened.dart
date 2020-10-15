import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:utility/models/response_structure.dart';

class OpenedSlider extends StatefulWidget {
  final Future<ResponseWithGPX> response;
  final List<Marker> markers;
  final GoogleMapController mapController;
  final SheetController sliderController;

  OpenedSlider(
      {Key key,
      this.response,
      this.markers,
      this.mapController,
      this.sliderController})
      : super(key: key);

  @override
  OpenedSliderState createState() => OpenedSliderState();
}

class OpenedSliderState extends State<OpenedSlider> {
  List<FlSpot> spotList = [];
  List<Marker> markers;
  Future<ResponseWithGPX> futureResponse;
  ResponseWithGPX completedResponse;
  ScrollController scrollController;
  bool show = false;
  int contOfSixty = 0;

  static const textStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'sans-serif-medium',
    fontSize: 15,
  );
  final divider = Container(
    height: 1,
    color: Colors.grey.shade300,
  );

  @override
  void initState() {
    super.initState();
    futureResponse = widget.response;
    markers = widget.markers;

    futureResponse.then((value) {
      setState(() {
        completedResponse = value;
        scrollController = new ScrollController();
      });
    });
  }

  /// Takes care of building the content of the slider
  @override
  Widget build(BuildContext context) {
    final titleStyle = textStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    const padding = EdgeInsets.symmetric(horizontal: 16);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 32),
        Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Informazioni percorso',
                style: titleStyle,
              ),
              _buildRouteDescription(context),

              const SizedBox(height: 15),
              Text(
                "Grafico dislivello",
                style: titleStyle,
              ),
              const SizedBox(height: 15),
              //TODO TRY WITH EXPAND
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: padding,
                    child: widget.mapController == null
                        ? Text("Loading...")
                        : _loadChart(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "Punti di interesse",
                style: titleStyle,
              ),
              const SizedBox(height: 15),
              completedResponse == null
                  ? Text("Loading")
                  : _buildCards(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildCards(BuildContext context) {
    int cardIndex = 0;

    return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: markers != null ? markers.length : 0,
          shrinkWrap: true,
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shadowColor: Colors.black,
                  child: Container(
                    width: 220.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  markers[position].infoWindow.title,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("Via: "),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("Distanza:"),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Cerca"),
                              IconButton(
                                icon: Icon(
                                  Icons.location_on,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _moveCamera(position);
                                  widget.mapController.showMarkerInfoWindow(
                                    markers[position].markerId,
                                  );
                                  widget.sliderController.collapse();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onHorizontalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dx > 0) {
                  //if (cardIndex > 0) cardIndex--;
                  cardIndex--;
                } else {
                  //if (cardIndex < 2) cardIndex++;
                  cardIndex++;
                }
                setState(() {
                  scrollController.animateTo(
                    (cardIndex) * 256.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                });
              },
            );
          },
        ));
  }

  _moveCamera(int position) {
    widget.mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            markers[position].position.latitude,
            markers[position].position.longitude,
          ),
          zoom: 15,
          tilt: 0,
          bearing: 0,
        ),
      ),
    );
  }

  LineChart _loadChart() {
    double cont = 0;

    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    completedResponse.elevationList.forEach((element) {
      if (cont % 5 == 0) {
        spotList.add(FlSpot(cont, element));
      }
      cont += 1;
    });

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(bottomTitles: SideTitles(showTitles: false)),
        lineBarsData: [
          LineChartBarData(
            spots: completedResponse == null ? [FlSpot(0, 0)] : spotList,
            isCurved: true,
            colors: gradientColors,
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteDescription(BuildContext context) {
    final steps = completedResponse == null
        ? []
        : [
            Step("Nome percorso: ", completedResponse.id),
            Step("Difficoltà: ", completedResponse.difficulty),
            Step("Durata: ", completedResponse.time),
            Step("Lunghezza: ", completedResponse.km),
            Step("Dislivello: ", completedResponse.ascent),
            Step("Descrizione: ", completedResponse.description),
          ];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, i) {
        final step = steps[i];

        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  step.field + step.val,
                  style: textStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
              ),
              divider,
            ],
          ),
        );
      },
    );
  }
}

class Step {
  final String field;
  final String val;
  Step(
    this.field,
    this.val,
  );
}

class Traffic {
  final double intesity;
  final String time;
  Traffic(
    this.intesity,
    this.time,
  );
}
