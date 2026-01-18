import 'package:flutter/scheduler.dart';

class FPSMonitor {
  void start(void Function(int) callback) {
    int lastFrameTime = 0;
    SchedulerBinding.instance.addTimingsCallback((timings) {
      final frameTime = timings.first.totalSpan.inMilliseconds;
      final fps = frameTime == 0 ? 0 : (1000 / frameTime).round();
      callback(fps);
      lastFrameTime = frameTime;
    });
  }
}
