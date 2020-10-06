import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:utility/util/response_structure.dart';

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
  bool show = false;
  /*TimeOfDay _lenght;
  double _doubleTimeLenght = 0;*/
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
  }

  /**
   * Takes care of building the content of the slider
   */
  @override
  Widget build(BuildContext context) {
    futureResponse.then((value) {
      debugPrint("FUNZIAAAA");
      completedResponse = value;
    });

    /*TODO Trying to add bottom data
      _lenght = TimeOfDay(
        hour: int.parse(value.time.split(":")[0]),
        minute: int.parse(value.time.split(":")[1]),
      );*/
    /* Convert TimeOfDay in double, subtract 30 till is less or equals to 0,
            count the number of times you subtracted 30 and insert a counter starting
            from 00:00 adding 30 minutes every time till the number counted earlier*/
    /*_doubleTimeLenght =
          (_lenght.hour.toDouble() * 60) + _lenght.minute.toDouble();*/
    //contOfSixty = _lenght.hour; //(_doubleTimeLenght / 30).round();

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
              const SizedBox(height: 15),
              Text(
                "Grafico dislivello",
                style: titleStyle,
              ),
              const SizedBox(height: 15),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: padding,
                    child: completedResponse == null ? null : mainData(),
                  ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        /*TODO OLD
        divider,
        const SizedBox(height: 32),
        InkWell(
          onTap: () => (() => show = !show),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Traffic',
                  style: titleStyle,
                ),
                const SizedBox(height: 16),
                buildChart(context),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        divider,
        const SizedBox(height: 32),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: padding,
              child: Text(
                'Steps',
                style: titleStyle,
              ),
            ),
            const SizedBox(height: 8),
            buildSteps(context),
          ],
        ),
        const SizedBox(height: 32),
        divider,
        const SizedBox(height: 32),
        Icon(
          MdiIcons.github,
          color: Colors.grey.shade900,
          size: 48,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Pull request are welcome!',
            style: textStyle.copyWith(
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: Text(
            '(Stars too)',
            style: textStyle.copyWith(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 32),*/
      ],
    );
  }

  LineChart mainData() {
    double cont = 0;
    /* TODO Trying to add values to the bottom bar
    List<int> titlesVal = [];
    int hour = 0, minutes = 0;
    int contPrint = 0;*/

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
    /* TODO Trying to add values to the bottom bar
    for (int x = 0; x <= 1000; x += 50) titlesVal.add(x);

    int jumpNumber = (1000 / contOfSixty).round();
    int temp = jumpNumber;
    int minimum = 2000;
    List<int> jumpList = [];

    for (int x = 0; x < contOfSixty + 1; x++) {
      for (int val in titlesVal) {
        if ((val - temp).abs() < minimum) {
          minimum = val;
        }
      }
      jumpList.add(minimum);
      minimum = 2000;
      temp = jumpNumber * x;
    }*/

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
        /* TODO Trying to add values to the bottom bar
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            textStyle: const TextStyle(
                color: Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 16),
            getTitles: (value) {
              if (jumpList.contains(value.toInt())) {
                String toPrint = hour.toString() + ":" + minutes.toString();
                if (minutes == 0) {
                  minutes = 30;
                } else {
                  minutes = 0;
                  hour += 1;
                }
                return toPrint;
              }
              return '';
              
              int jumpNumber = (cont / contOfSixty).round();
              debugPrint("JUMPPPPPP: " +
                  jumpNumber.toString() +
                  " CONTPRINT: " +
                  contPrint.toString() +
                  " VALUEEE: " +
                  value.toString());

              if (value.toInt() == (jumpNumber * contPrint)) {
                String toPrint = hour.toString() + ":" + minutes.toString();
                if (minutes == 0) {
                  minutes = 30;
                } else {
                  minutes = 0;
                  hour += 1;
                }
                contPrint = contPrint + 1;
                return toPrint;
              }
              return '';

              /*
              switch (value.toInt()) {
                case 0:
                  return 'MAR';
                case 500:
                  return 'JUN';
                case 900:
                  return 'SEP';
              }
              */
            },
            margin: 8,
          ),*/ /*
          leftTitles: SideTitles(
            showTitles: true,
            textStyle: const TextStyle(
              color: Color(0xff67727d),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return '10k';
                case 3:
                  return '30k';
                case 5:
                  return '50k';
              }
              return '';
            },
            reservedSize: 28,
            margin: 12,
          ),
        ),*/
        /*borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1)),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,*/
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
