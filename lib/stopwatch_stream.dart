import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Stopwatchstream {
  bool timerRunning = false;
  int counter = 0;
  Timer? timer;

  final StreamController<int> _controller = StreamController<int>.broadcast();

  Stopwatchstream() {
    _startTimer();
  }

  void _startTimer() {
    timerRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), tick);
  }

  Stream<int> getStream() {
    return _controller.stream;
  }

  void tick(Timer timer) {
    if (timerRunning) {
      counter++;
      _controller.add(counter);
    }
  }

  void pauseTimer() {
    timerRunning = false;
  }

  void resumeTimer() {
    if (!timerRunning) {
      timerRunning = true;
    }
  }

  void resetTimer() {
    counter = 0;
    _controller.add(counter);
    pauseTimer();
  }

  void dispose() {
    timer?.cancel();
    _controller.close();
  }
}

final stopwatchProvider = Provider<Stopwatchstream>((ref) {
   final stopwatch = Stopwatchstream();

   ref.onDispose(() {
    stopwatch.dispose();
  });

  return Stopwatchstream();
});

final stopwatchStreamProvider = StreamProvider((ref) async* {
  final streamData = ref.watch(stopwatchProvider).getStream();
  await for (final eachLiveData in streamData) {
    yield eachLiveData;
  }
});
