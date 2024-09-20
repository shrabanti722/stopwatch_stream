import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stopwatch_stream/stopwatch_stream.dart';

class StopWatch extends ConsumerWidget {
  const StopWatch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = ref.watch(stopwatchProvider);
    final stopwatch = ref.watch(stopwatchProvider.notifier);

    return ref.watch(stopwatchStreamProvider).when(
          data: (data) {
            final int tick = data;
            final hoursStr =
                ((tick / 3600) % 60).floor().toString().padLeft(2, '0');
            final minutesStr =
                ((tick / 60) % 60).floor().toString().padLeft(2, '0');
            final secondsStr = (tick % 60).floor().toString().padLeft(2, '0');

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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            backgroundColor: isRunning
                                ? Colors.blue
                                : Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            if (isRunning) {
                              stopwatch.pauseTimer();
                            } else {
                              stopwatch.resumeTimer();
                            }
                          },
                          child: Text(
                            isRunning ? 'PAUSE' : 'START',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                        const SizedBox(width: 40.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: stopwatch.resetTimer,
                          child: const Text(
                            'RESET',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          error: ((error, stackTrace) {
            return Text("${error.toString()}, $stackTrace");
          }),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
