import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import '../../domain/entities/candle.dart';

class RealCandleStickChart extends StatelessWidget {
  final List<CandleEntity> candles;

  RealCandleStickChart({required this.candles});

  @override
  Widget build(BuildContext context) {
    final items = candles.map((c) => Candle(
      date: c.time,
      open: c.open,
      high: c.high,
      low: c.low,
      close: c.close,
      volume: c.volume.toDouble(),
    )).toList();

    return Candlesticks(
      candles: items,
    );
  }
}
