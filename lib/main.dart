import 'package:flutter/material.dart';
import 'package:stopwatch_stream/stopwatch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: FlutterStopWatch(),
    );
  }
}
