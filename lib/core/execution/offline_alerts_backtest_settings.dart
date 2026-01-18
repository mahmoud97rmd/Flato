import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import '../../features/market/domain/entities/candle.dart';
import '../../core/timeframes/timeframe_utils.dart';

/// =================================================================
/// 1) OFFLINE STORAGE + REPLAY MANAGER
/// =================================================================

class OfflineHistoryManager {
  static const String boxName = "offline_history";

  static Future<void> init() async {
    await Hive.openBox<List>(boxName);
  }

  static List<Candle>? load(String symbol, String timeframe) {
    final box = Hive.box<List>(boxName);
    final data = box.get("\$symbol|\$timeframe");
    if (data == null) return null;
    return data.cast<Candle>();
  }

  static Future<void> save(String symbol, String timeframe,
      List<Candle> data) async {
    final box = Hive.box<List>(boxName);
    await box.put("\$symbol|\$timeframe", data);
  }
}

/// Replay Engine

typedef ReplayCallback = void Function(Candle);

class ReplayEngine {
  bool _paused = false;
  Timer? _timer;

  void start(List<Candle> history,
      {required ReplayCallback onFrame,
      Duration interval = const Duration(milliseconds: 300)}) {
    int index = 0;
    _paused = false;

    _timer?.cancel();
    _timer = Timer.periodic(interval, (t) {
      if (_paused || index >= history.length) {
        t.cancel();
        return;
      }
      onFrame(history[index]);
      index++;
    });
  }

  void pause() => _paused = true;
  void resume() => _paused = false;
  void stop() {
    _timer?.cancel();
    _paused = false;
  }
}

/// =================================================================
/// 2) ALERTS ENGINE
/// =================================================================

class Alert {
  final String id;
  final String symbol;
  final String condition; // e.g. "RSI<30"
  final bool active;

  Alert({
    required this.id,
    required this.symbol,
    required this.condition,
    this.active = true,
  });
}

class AlertEngine {
  final List<Alert> _alerts = [];
  final StreamController<Alert> _triggered =
      StreamController<Alert>.broadcast();

  Stream<Alert> get triggered => _triggered.stream;

  void add(Alert alert) {
    _alerts.add(alert);
  }

  void remove(String id) {
    _alerts.removeWhere((a) => a.id == id);
  }

  void evaluate(Candle candle) {
    for (var a in _alerts) {
      if (!a.active) continue;
      // مثال بسيط: RSI<30
      if (a.condition.startsWith("RSI<")) {
        final threshold =
            int.parse(a.condition.split("<")[1].trim());
        if (candle.close < threshold) {
          _triggered.add(a);
        }
      }
    }
  }

  void dispose() {
    _triggered.close();
  }
}

/// =================================================================
/// 3) BACKTEST VISUALIZATION
/// =================================================================

class BacktestResult {
  final double netProfit;
  final double maxDrawdown;
  final int totalTrades;
  final List<double> equityCurve;

  BacktestResult({
    required this.netProfit,
    required this.maxDrawdown,
    required this.totalTrades,
    required this.equityCurve,
  });
}

class BacktestVisualizer {
  List<double> computeEquityCurve(List<double> returns) {
    List<double> curve = [];
    double total = 0;
    for (var r in returns) {
      total += r;
      curve.add(total);
    }
    return curve;
  }

  Widget equityCurveChart(List<double> curve) {
    return CustomPaint(
      size: Size.infinite,
      painter: _EquityCurvePainter(curve),
    );
  }
}

class _EquityCurvePainter extends CustomPainter {
  final List<double> curve;
  _EquityCurvePainter(this.curve);

  @override
  void paint(Canvas canvas, Size size) {
    if (curve.isEmpty) return;
    double maxY = curve.reduce((a, b) => a > b ? a : b);
    double minY = curve.reduce((a, b) => a < b ? a : b);

    var paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    var path = Path();
    for (int i = 0; i < curve.length; i++) {
      double x = (i / curve.length) * size.width;
      double y = size.height - ((curve[i] - minY) / (maxY - minY)) * size.height;
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EquityCurvePainter old) =>
      old.curve != curve;
}

/// =================================================================
/// 4) SETTINGS + THEME PERSISTENCE
/// =================================================================

class AppSettings {
  static const String boxName = "app_settings";

  static Future<void> init() async {
    await Hive.openBox(boxName);
  }

  static void saveThemeMode(ThemeMode mode) {
    final box = Hive.box(boxName);
    box.put("theme_mode", mode.index);
  }

  static ThemeMode loadThemeMode() {
    final box = Hive.box(boxName);
    final idx = box.get("theme_mode") ?? ThemeMode.system.index;
    return ThemeMode.values[idx];
  }

  static void saveIndicatorPrefs(List<String> prefs) {
    final box = Hive.box(boxName);
    box.put("indicator_prefs", prefs);
  }

  static List<String> loadIndicatorPrefs() {
    final box = Hive.box(boxName);
    return (box.get("indicator_prefs") ?? []).cast<String>();
  }
}
