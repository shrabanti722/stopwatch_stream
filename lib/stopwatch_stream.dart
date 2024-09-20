import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StopWatch {
  final bool _timerRunning;
  final int _counter;
  final Timer? _timer;

  StopWatch({required bool timerRunning, Timer? timer, int? counter}) : _timerRunning =  timerRunning, _timer=timer, _counter= counter ?? 0;

  bool get timerRunning => _timerRunning;
  int get counter => _counter;
  Timer? get timer => _timer;

    StopWatch copyWith({bool? timerRunning, Timer? timer, int? counter}) {
    return StopWatch(
      timerRunning : timerRunning ?? _timerRunning, timer: timer ?? _timer, counter: counter ?? _counter,
    );
  }
}

class Stopwatchstream extends StateNotifier<StopWatch>  {

  final StreamController<int> _controller = StreamController<int>.broadcast();

   Stopwatchstream() : super((StopWatch(timerRunning: true))) {
    _startTimer();
  }

  void _startTimer() {
    state = state.copyWith(timerRunning: true, timer: Timer.periodic(const Duration(seconds: 1), tick));
  }

  Stream<int> getStream() {
    return _controller.stream;
  }

  void tick(Timer timer) {
    if (state.timerRunning) {
      state = state.copyWith(counter: state.counter + 1);
      _controller.add(state.counter);
    }
  }

  void pauseTimer() {
    state = state.copyWith(timerRunning: false);
  }

  void resumeTimer() {
    if (!state.timerRunning) {
      state = state.copyWith(timerRunning: true);
    }
  }

  void resetTimer() {
    state = state.copyWith(counter: 0);
    _controller.add(0);
    pauseTimer();
  }

  @override
  void dispose() {
    state.timer?.cancel();
    _controller.close();
    super.dispose();
  }
}

final stopwatchProvider = StateNotifierProvider<Stopwatchstream, StopWatch>((ref) {
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
