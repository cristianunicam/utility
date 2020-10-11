import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:utility/map_page/bottom_slider/point_of_interes.dart';
import 'package:utility/util/response_structure.dart';
import 'package:google_maps_webservice/places.dart';

class OpenedSlider extends StatefulWidget {
  Future<Response> response;

  OpenedSlider({Key key, this.response}) : super(key: key);

  @override
  OpenedSliderState createState() => OpenedSliderState();
}

class OpenedSliderState extends State<OpenedSlider> {
  List<FlSpot> spotList = [];
  Future<Response> futureResponse;
  Response completedResponse;
  ScrollController scrollController;
  bool show = false;
  int contOfSixty = 0;

  static const textStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'sans-serif-medium',
    fontSize: 15,
  );

  @override
  void initState() {
    super.initState();
    futureResponse = widget.response;
    futureResponse.then((value) {
      completedResponse = value;
      scrollController = new ScrollController();
    });
  }

  /**
   * Takes care of building the content of the slider
   */
  @override
  Widget build(BuildContext context) {
    final divider = Container(
      height: 1,
      color: Colors.grey.shade300,
    );

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
              const SizedBox(height: 16),
              Text(
                "Nome percorso: " +
                    (completedResponse == null ? "nome" : completedResponse.id),
              ),
              const SizedBox(height: 5),
              Text(
                "Difficoltà: " +
                    (completedResponse == null
                        ? "Difficoltà"
                        : completedResponse.difficulty),
              ),
              const SizedBox(height: 5),
              Text(
                "Durata: " +
                    (completedResponse == null
                        ? "Durata"
                        : completedResponse.time + " ore"),
              ),
              const SizedBox(height: 5),
              Text("Lunghezza: " +
                  (completedResponse == null ? "" : completedResponse.km) +
                  " km"),
              const SizedBox(height: 5),
              Text("Dislivello: " +
                  (completedResponse == null ? "" : completedResponse.ascent) +
                  " metri"),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Descrizione: " +
                    (completedResponse == null
                        ? "Descrizione"
                        : completedResponse.description),
              ),
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
                    child: completedResponse == null ? null : _loadChart(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "Punti di interesse",
                style: titleStyle,
              ),
              const SizedBox(height: 15),
              completedResponse == null ? Text("Loading") : _loadCards(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Container _loadCards(BuildContext context) {
    int cardIndex = 0;

    return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          shrinkWrap: true,
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    width: 220.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              /*Icon(
                            cardsList[position].icon,
                            color: appColors[position],
                          ),*/
                              Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  "Colonna num ${position + 1}",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  "null",
                                  //"${cardsList[position].cardTitle}",
                                  style: TextStyle(fontSize: 28.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: LinearProgressIndicator(),
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

  Widget buildSteps(BuildContext context) {
    final steps = [
      Step('Go to your pubspec.yaml file.', '2 seconds'),
      Step("Add the newest version of 'sliding_sheet' to your dependencies.",
          '5 seconds'),
      Step("Run 'flutter packages get' in the terminal.", '4 seconds'),
      Step("Happy coding!", 'Forever'),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, i) {
        final step = steps[i];

        return Padding(
          padding: const EdgeInsets.fromLTRB(56, 16, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                step.instruction,
                style: textStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Text(
                    '${step.time}',
                    style: textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget buildChart(BuildContext context) {
    final series = [
      charts.Series<Traffic, String>(
        id: 'traffic',
        data: [
          Traffic(0.5, '14:00'),
          Traffic(0.6, '14:30'),
          Traffic(0.5, '15:00'),
          Traffic(0.7, '15:30'),
          Traffic(0.8, '16:00'),
          Traffic(0.6, '16:30'),
        ],
        colorFn: (traffic, __) {
          if (traffic.time == '14:30')
            return charts.Color.fromHex(code: '#F0BA64');
          return charts.MaterialPalette.gray.shade300;
        },
        domainFn: (Traffic traffic, _) => traffic.time,
        measureFn: (Traffic traffic, _) => traffic.intesity,
      ),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: show ? 256 : 128,
      color: Colors.transparent,
      child: charts.BarChart(
        series,
        animate: true,
        domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(
              fontSize: 12, // size in Pts.
              color: charts.MaterialPalette.gray.shade500,
            ),
          ),
        ),
        defaultRenderer: charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(5),
        ),
      ),
    );
  }
}

class Step {
  final String instruction;
  final String time;
  Step(
    this.instruction,
    this.time,
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
