import 'dart:collection';
import '../../entities/candle.dart';
import '../smart/smart_alert.dart';
import '../../../indicators/advanced/rsi_calculator.dart';
import '../../../indicators/advanced/macd_calculator.dart';
import '../../../indicators/advanced/bollinger_calculator.dart';

class SmartAlertEngine {
  final List<CandleEntity> history;
  final List<SmartAlert> activeAlerts;
  final int checkIntervalSeconds;

  SmartAlertEngine({
    required this.history,
    required this.activeAlerts,
    this.checkIntervalSeconds = 60,
  });

  void processNewCandle(CandleEntity candle) {
    history.add(candle);

    for (var alert in activeAlerts) {
      if (alert.isTriggered) continue;

      switch (alert.condition.type) {
        case SmartAlertType.rsiBelow:
          _checkRsiBelow(alert);
          break;
        case SmartAlertType.macdCrossUp:
          _checkMacdCross(alert);
          break;
        case SmartAlertType.bollingerBreakoutUpper:
          _checkBollingerUpper(alert);
          break;
      }
    }
  }

  void _checkRsiBelow(SmartAlert alert) {
    final rsi = RsiCalculator.calculate(history, period: alert.condition.threshold.toInt()).values;
    int countBelow = 0;
    for (int i = rsi.length - alert.condition.durationSeconds; i < rsi.length; i++) {
      if (rsi[i] < alert.condition.threshold) countBelow++;
    }
    if (countBelow >= alert.condition.durationSeconds) {
      alert.isTriggered = true;
    }
  }

  void _checkMacdCross(SmartAlert alert) {
    final macd = MacdCalculator.calculate(history).macdLine;
    final signal = MacdCalculator.calculate(history).signalLine;
    if (macd.isNotEmpty && signal.isNotEmpty) {
      int n = macd.length;
      if (n > 1 && macd[n - 2] < signal[n - 2] && macd[n - 1] > signal[n - 1]) {
        alert.isTriggered = true;
      }
    }
  }

  void _checkBollingerUpper(SmartAlert alert) {
    final bb = BollingerCalculator.calculate(history);
    double lastPrice = history.last.close;
    if (lastPrice > bb.upperBand.last) alert.isTriggered = true;
  }
}
