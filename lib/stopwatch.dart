import 'dart:async';

import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

   @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  bool timerRunning = false;
  int counter = 0;
  Stream<int>? timerStream;
  StreamSubscription<int>? timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  Stream<int> timedCounter(Duration interval) {
    StreamController<int> controller = StreamController<int>();
    Timer? timer;

    void tick(_) {
      counter++;
      controller.add(counter); // Ask stream to send counter values as event.
      // if (counter == maxCount) {
      //   timer?.cancel();
      //   controller.close(); // Ask stream to shut down and tell listeners.
      // }
    }

    void startTimer() {
      setState(() {
        timerRunning = true;
      });
      timer = Timer.periodic(interval, tick);
    }

    void stopTimer() {
       if (timer != null) {
        setState(() {
        timerRunning = false;
      });
       timer?.cancel();
        timer = null;
        counter = 0;
        controller.close();
      }
    }

    void pauseTimer() {
       if (timer != null) {
        setState(() {
        timerRunning = false;
      });
       timer?.cancel();
       timer = null;
      }
    }

    controller = StreamController<int>(
        onListen: startTimer,
        onPause: pauseTimer,
        onResume: startTimer,
        onCancel: stopTimer);

    return controller.stream;
  }

  @override
  void dispose() {
    timerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter StopWatch")),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      backgroundColor:
                          timerRunning ? Colors.blue : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      timerStream = timedCounter(const Duration(seconds: 1));
                      if (timerRunning) {
                        timerSubscription?.pause();
                      } else {
                        timerSubscription = timerStream?.listen((int newTick) {
                          setState(() {
                            hoursStr = ((newTick / (60 * 60)) % 60)
                                .floor()
                                .toString()
                                .padLeft(2, '0');
                            minutesStr = ((newTick / 60) % 60)
                                .floor()
                                .toString()
                                .padLeft(2, '0');
                            secondsStr = (newTick % 60)
                                .floor()
                                .toString()
                                .padLeft(2, '0');
                          });
                          debugPrint(
                            'timerRunning === $timerRunning',
                          );
                        });
                      }
                    },
                    child: Text(
                      timerRunning ? 'PAUSE' : 'START',
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    )),
                const SizedBox(width: 40.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    timerSubscription?.cancel();
                    timerStream = null;
                    setState(() {
                      hoursStr = '00';
                      minutesStr = '00';
                      secondsStr = '00';
                    });
                  },
                  child: const Text(
                    'RESET',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
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
