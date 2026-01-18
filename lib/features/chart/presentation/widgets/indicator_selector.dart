import 'package:flutter/material.dart';
import '../../../domain/indicators/indicator_manager.dart';
import '../../../domain/indicators/ema_indicator.dart';
import '../../../domain/indicators/rsi_indicator.dart';
import '../../../domain/indicators/macd_indicator.dart';

class IndicatorSelector extends StatelessWidget {
  final IndicatorManager manager;
  const IndicatorSelector({required this.manager});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ElevatedButton(
          child: Text("EMA(14)"),
          onPressed: () => manager.add(EMAIndicator(14)),
        ),
        ElevatedButton(
          child: Text("RSI(14)"),
          onPressed: () => manager.add(RSIIndicator(14)),
        ),
        ElevatedButton(
          child: Text("MACD"),
          onPressed: () => manager.add(MACDIndicator()),
        ),
        ElevatedButton(
          child: Text("Clear All"),
          onPressed: () => manager.clear(),
        ),
      ],
    );
  }
}
