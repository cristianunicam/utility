import 'package:flutter/material.dart';

import 'main_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static BuildContext context;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Utility',
      theme: ThemeData(
        primaryColor: Color(0xFF90CAF9),
      ),
      home: MainList(),
    );
  }
}
