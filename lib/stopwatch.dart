import 'dart:async';

import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

  @override
  State<StopWatch> createState() => StopWatchState();
}

class StopWatchState extends State<StopWatch> {
  bool timerRunning = false;
  int counter = 0;
  Timer? timer;
  StreamController<int>? controller;
  StreamSubscription<int>? timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

   void tick(_) {
      counter++;
      controller!.add(counter);
    }

  void startTimer() {
    if (controller == null) {
      controller = StreamController<int>();
      timer = Timer.periodic(const Duration(seconds: 1), tick);
    }
    setState(() {
      timerRunning = true;
    });
    timerSubscription = controller!.stream.listen((int newTick) {
      setState(() {
        hoursStr = ((newTick / 3600) % 60).floor().toString().padLeft(2, '0');
        minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
        secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
      });
    });
  }

  void pauseTimer() {
    setState(() {
      timerRunning = false;
    });
    timerSubscription?.pause();
    timer?.cancel();
    timer = null;
  }

  void resumeTimer() {
    if (controller != null && timer == null) {
      timer = Timer.periodic(const Duration(seconds: 1), tick);
    }
    setState(() {
      timerRunning = true;
    });
    timerSubscription?.resume();
  }

  void resetTimer() {
    timerSubscription?.cancel();
    controller?.close();
    timer?.cancel();
    controller = null;
    timer = null;
    setState(() {
      timerRunning = false;
      counter = 0;
      hoursStr = '00';
      minutesStr = '00';
      secondsStr = '00';
    });
  }

  @override
  void dispose() {
    timerSubscription?.cancel();
    controller?.close();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("StopWatch")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$hoursStr:$minutesStr:$secondsStr",
              style: const TextStyle(
                fontSize: 90.0,
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    backgroundColor: timerRunning ? Colors.blue : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (timerRunning) {
                      pauseTimer();
                    } else {
                      if (controller == null) {
                        startTimer();
                      } else {
                        resumeTimer();
                      }
                    }
                  },
                  child: Text(
                    timerRunning ? 'PAUSE' : 'START',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
                const SizedBox(width: 40.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: resetTimer,
                  child: const Text(
                    'RESET',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
