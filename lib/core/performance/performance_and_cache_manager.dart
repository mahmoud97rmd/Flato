import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';
import '../../features/market/domain/entities/candle.dart';

/// ============================================================
/// 1) HISTORY CACHE MANAGER (Memory + Paging + Throttle WS)
/// ============================================================

class HistoryCacheManager {
  final Map<String, List<Candle>> _cache = {};

  // Load and cache history
  List<Candle> load(String key, List<Candle> data) {
    _cache[key] = data;
    return _cache[key]!;
  }

  // Get cached
  List<Candle>? get(String key) => _cache[key];

  // Clear
  void clear(String key) => _cache.remove(key);

  // Clear all
  void clearAll() => _cache.clear();
}

/// ===============================================
/// 2) WebSocket Debouncer / Throttler
/// ===============================================

class WsThrottle {
  final Duration duration;
  Timer? _timer;
  final List<Map<String, dynamic>> _buffer = [];

  WsThrottle([this.duration = const Duration(milliseconds: 250)]);

  void call(Map<String, dynamic> data, void Function(Map<String, dynamic>) emit) {
    _buffer.add(data);

    _timer?.cancel();
    _timer = Timer(duration, () {
      if (_buffer.isNotEmpty) {
        final last = _buffer.last;
        _buffer.clear();
        emit(last);
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _buffer.clear();
  }
}

/// ===============================================
/// 3) Custom Painter Cache (RepaintBoundary Helper)
/// ===============================================

class CachedPainter extends CustomPainter {
  final List<Candle> candles;
  final CustomPainter innerPainter;

  CachedPainter({required this.candles, required this.innerPainter});

  @override
  void paint(Canvas canvas, Size size) {
    innerPainter.paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CachedPainter oldDelegate) {
    // Only redraw when data changes
    final eq = ListEquality().equals;
    return !eq(oldDelegate.candles, candles);
  }
}

/// ===============================================
/// 4) Canvas Update Scheduler
/// ===============================================

class RenderScheduler {
  bool _locked = false;

  void requestRender(VoidCallback callback) {
    if (_locked) return;
    _locked = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
      _locked = false;
    });
  }
}
