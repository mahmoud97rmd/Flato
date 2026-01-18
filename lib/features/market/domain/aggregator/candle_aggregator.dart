import 'dart:collection';

class LiveCandle {
  final int time; // unix seconds
  double open;
  double high;
  double low;
  double close;

  LiveCandle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  Map<String, dynamic> toMap() {
    return {
      "time": time,
      "open": open,
      "high": high,
      "low": low,
      "close": close,
    };
  }
}

class CandleAggregator {
  LiveCandle? _currentCandle;
  final Duration timeframe;
  final Queue<Map<String, dynamic>> _pendingTicks = Queue();

  CandleAggregator(this.timeframe);

  /// يحوّل Timestamp إلى بداية الشمعة الصحيحة
  int _alignTime(int unixSeconds) {
    final bucket = timeframe.inSeconds;
    return (unixSeconds ~/ bucket) * bucket;
  }

  /// يستقبل Tick ويحدّث الشمعة أو ينشئ واحدة جديدة
  LiveCandle processTick(Map<String, dynamic> tick) {
    final int ts = tick["time"] as int;
    final double price = tick["price"] as double;
    final alignedTime = _alignTime(ts);

    // إذا لا توجد شمعة حالية -> أنشئها
    if (_currentCandle == null) {
      _currentCandle = LiveCandle(
        time: alignedTime,
        open: price,
        high: price,
        low: price,
        close: price,
      );
      return _currentCandle!;
    }

    // إذا تغيّر إطار الزمن -> أغلق القديمة وابدأ جديدة
    if (_currentCandle!.time != alignedTime) {
      final closed = _currentCandle!;
      _currentCandle = LiveCandle(
        time: alignedTime,
        open: price,
        high: price,
        low: price,
        close: price,
      );
      return closed; // نعيد الشمعة المغلقة أولًا
    }

    // تحديث الشمعة الحالية
    _currentCandle!.high =
        price > _currentCandle!.high ? price : _currentCandle!.high;
    _currentCandle!.low =
        price < _currentCandle!.low ? price : _currentCandle!.low;
    _currentCandle!.close = price;

    return _currentCandle!;
  }

  /// عند انقطاع الاتصال ثم عودته: نخزن Ticks المتأخرة
  void bufferTick(Map<String, dynamic> tick) {
    _pendingTicks.add(tick);
  }

  /// ملء الفجوات بعد إعادة الاتصال
  List<LiveCandle> flushBufferedTicks() {
    final List<LiveCandle> candles = [];
    while (_pendingTicks.isNotEmpty) {
      candles.add(processTick(_pendingTicks.removeFirst()));
    }
    return candles;
  }
}
