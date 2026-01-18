import '../entities/candle.dart';
import '../indicators/ema_calculator.dart';
import '../indicators/stochastic_calculator.dart';
import 'strategy_config.dart';

enum TradeSignal { BUY, SELL, NONE }

class StrategyManager {
  final List<CandleEntity> data;
  final StrategyConfig config;

  DateTime? _lastSignalTime;
  TradeSignal _lastSignal = TradeSignal.NONE;

  StrategyManager(this.data, this.config);

  TradeSignal evaluate() {
    if (data.length < config.emaLong) return TradeSignal.NONE;

    final emaShortVals = EmaCalculator.calculate(
      data: data,
      period: config.emaShort,
    ).values;

    final emaLongVals = EmaCalculator.calculate(
      data: data,
      period: config.emaLong,
    ).values;

    final stoch = StochasticCalculator.calculate(
      data: data,
      period: config.stochPeriod,
      smoothK: config.stochSmoothK,
      smoothD: config.stochSmoothD,
    );

    final int idx = data.length - 1;

    final bool bullCond = emaShortVals[idx] > emaLongVals[idx] &&
        stoch.kValues[idx] > stoch.dValues[idx] &&
        stoch.kValues[idx] < 80;

    final bool bearCond = emaShortVals[idx] < emaLongVals[idx] &&
        stoch.kValues[idx] < stoch.dValues[idx] &&
        stoch.kValues[idx] > 20;

    final now = data[idx].time;

    if (bullCond && _canSignal(now, TradeSignal.BUY)) {
      _updateLastSignal(now, TradeSignal.BUY);
      return TradeSignal.BUY;
    }

    if (bearCond && _canSignal(now, TradeSignal.SELL)) {
      _updateLastSignal(now, TradeSignal.SELL);
      return TradeSignal.SELL;
    }

    return TradeSignal.NONE;
  }

  bool _canSignal(DateTime now, TradeSignal signal) {
    if (_lastSignal == signal && _lastSignalTime != null) {
      final diff = now.difference(_lastSignalTime!).inSeconds;
      if (diff < config.minSignalIntervalSeconds) {
        return false;
      }
    }
    return true;
  }

  void _updateLastSignal(DateTime now, TradeSignal signal) {
    _lastSignalTime = now;
    _lastSignal = signal;
  }
}
