import 'package:flutter/material.dart';
import 'gmaps_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Utility',
      theme: ThemeData(
        primaryColor: Color(0xFF90CAF9),
      ),
      home: GMapSlider(),
    );
  }
}
