import 'package:flutter/material.dart';
import 'package:stopwatch_stream/stopwatch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Stopwatch',
      home: StopWatch(),
    );
  }
}
