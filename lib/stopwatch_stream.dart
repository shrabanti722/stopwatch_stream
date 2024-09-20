import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Stopwatchstream extends StateNotifier<bool>  {
  // bool timerRunning = false;
  int counter = 0;
  Timer? timer;

  final StreamController<int> _controller = StreamController<int>.broadcast();

   Stopwatchstream() : super(false) {
    _startTimer();
  }

  void _startTimer() {
    state = true;
    timer = Timer.periodic(const Duration(seconds: 1), tick);
  }

  Stream<int> getStream() {
    return _controller.stream;
  }

  void tick(Timer timer) {
    if (state) {
      counter++;
      _controller.add(counter);
    }
  }

  void pauseTimer() {
    state = false;
  }

  void resumeTimer() {
    if (!state) {
      state = true;
    }
  }

  void resetTimer() {
    counter = 0;
    _controller.add(counter);
    pauseTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.close();
    super.dispose();
  }
}

final stopwatchProvider = StateNotifierProvider<Stopwatchstream, bool>((ref) {
   final stopwatch = Stopwatchstream();

   ref.onDispose(() {
    stopwatch.dispose();
  });

  return Stopwatchstream();
});

final stopwatchStreamProvider = StreamProvider((ref) async* {
  final streamData = ref.watch(stopwatchProvider.notifier).getStream();
  await for (final eachLiveData in streamData) {
    yield eachLiveData;
  }
});
