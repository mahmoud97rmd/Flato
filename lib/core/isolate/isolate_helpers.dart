import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../features/market/domain/indicators/ema.dart';
import '../../features/market/domain/indicators/stochastic.dart';
import '../../features/market/domain/entities/candle.dart';

class IndicatorParams {
  final List<Candle> candles;
  final int emaShort;
  final int emaLong;
  final int stochPeriod;
  final int stochSmoothK;
  final int stochSmoothD;

  IndicatorParams({
    required this.candles,
    required this.emaShort,
    required this.emaLong,
    required this.stochPeriod,
    required this.stochSmoothK,
    required this.stochSmoothD,
  });
}

class IndicatorResult {
  final List<double> emaShort;
  final List<double> emaLong;
  final List<double> stochK;
  final List<double> stochD;

  IndicatorResult({
    required this.emaShort,
    required this.emaLong,
    required this.stochK,
    required this.stochD,
  });
}

Future<IndicatorResult> computeIndicatorsInBackground(IndicatorParams params) async {
  return await compute(_calculateIndicators, params);
}

IndicatorResult _calculateIndicators(IndicatorParams params) {
  try {
    final emaShort = calculateEMA(params.candles, params.emaShort);
    final emaLong = calculateEMA(params.candles, params.emaLong);
    final stochK = calculateStochK(params.candles, params.stochPeriod, params.stochSmoothK);
    final stochD = smoothStochD(stochK, params.stochSmoothD);

    return IndicatorResult(
      emaShort: emaShort,
      emaLong: emaLong,
      stochK: stochK,
      stochD: stochD,
    );
  } catch (e) {
    log("Indicator isolate error: $e");
    rethrow;
  }
}
