import 'dart:async';

import 'package:flutter/material.dart';

class StopwachStreamController {
  StreamController<int> controller = StreamController<int>.broadcast();

  Stream<int> get stream => controller.stream;
  
  void addTick(int tick) {
    controller.add(tick);
  }

  void dispose() {
    controller.close();
  }
}

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

  @override
  State<StopWatch> createState() => StopWatchState();
}

class StopWatchState extends State<StopWatch> {
  bool timerRunning = false;
  int counter = 0;
  Timer? timer;
  final StopwachStreamController controller = StopwachStreamController();

   void tick(_) {
      counter++;
      controller.addTick(counter);
    }

  // void startTimer() {
  //   if (controller == null) {
  //     controller = StreamController<int>();
  //     timer = Timer.periodic(const Duration(seconds: 1), tick);
  //   }
  //   setState(() {
  //     timerRunning = true;
  //   });
  //   timerSubscription = controller!.stream.listen((int newTick) {
  //     setState(() {
  //       hoursStr = ((newTick / 3600) % 60).floor().toString().padLeft(2, '0');
  //       minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
  //       secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
  //     });
  //   });
  // }

  void startTimer() {
    timer ??= Timer.periodic(const Duration(seconds: 1), tick);
    setState(() {
      timerRunning = true;
    });
  }

  void pauseTimer() {
    setState(() {
      timerRunning = false;
    });
    // timerSubscription?.pause();
    timer?.cancel();
    timer = null;
  }

  // void resumeTimer() {
  //   if (controller != null && timer == null) {
  //     timer = Timer.periodic(const Duration(seconds: 1), tick);
  //   }
  //   setState(() {
  //     timerRunning = true;
  //   });
  //   timerSubscription?.resume();
  // }

   void resumeTimer() {
    timer ??= Timer.periodic(const Duration(seconds: 1), tick);
    setState(() {
      timerRunning = true;
    });
  }

  // void resetTimer() {
  //   timerSubscription?.cancel();
  //   controller?.close();
  //   timer?.cancel();
  //   controller = null;
  //   timer = null;
  //   setState(() {
  //     timerRunning = false;
  //     counter = 0;
  //     hoursStr = '00';
  //     minutesStr = '00';
  //     secondsStr = '00';
  //   });
  // }

  void resetTimer() {
    timer?.cancel();
    timer = null;
    controller.addTick(0);
    setState(() {
      timerRunning = false;
      counter = 0;
    });
  }


   @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
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
            StreamBuilder<int>(
              stream: controller.stream,
              builder: (context, snapshot) {
                final int tick = snapshot.data ?? 0;
                final hoursStr = ((tick / 3600) % 60).floor().toString().padLeft(2, '0');
                final minutesStr = ((tick / 60) % 60).floor().toString().padLeft(2, '0');
                final secondsStr = (tick % 60).floor().toString().padLeft(2, '0');
                return Text(
                  "$hoursStr:$minutesStr:$secondsStr",
                  style: const TextStyle(
                    fontSize: 90.0,
                  ),
                );
              },
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
