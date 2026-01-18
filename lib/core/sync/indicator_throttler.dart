import 'dart:async';

class IndicatorThrottler {
  final Duration delay;
  Timer? _timer;
  List<dynamic> _pending = [];

  IndicatorThrottler({this.delay = const Duration(milliseconds: 50)});

  void add(dynamic data, void Function(List<dynamic>) compute) {
    _pending.add(data);
    _timer?.cancel();
    _timer = Timer(delay, () {
      compute(_pending);
      _pending.clear();
    });
  }
}
