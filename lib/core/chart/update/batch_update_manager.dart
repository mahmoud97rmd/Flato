import 'dart:async';

class BatchUpdateManager {
  final Duration delay;
  Timer? _timer;
  List<dynamic> _pending = [];

  BatchUpdateManager({this.delay = const Duration(milliseconds: 50)});

  void add(dynamic data, void Function(List<dynamic>) callback) {
    _pending.add(data);
    _timer?.cancel();
    _timer = Timer(delay, () {
      callback(_pending);
      _pending.clear();
    });
  }
}
