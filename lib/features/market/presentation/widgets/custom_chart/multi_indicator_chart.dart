import 'package:flutter/material.dart';
import '../../../domain/indicators/types/indicator_series.dart';

class MultiIndicatorChart extends StatelessWidget {
  final List<double> prices;
  final List<IndicatorSeries> indicators;

  MultiIndicatorChart({
    required this.prices,
    required this.indicators,
  });

  @override
  Widget build(BuildContext context) {
    final overlaySeries =
        indicators.where((i) => i.displayMode == IndicatorDisplayMode.overlay);
    final subCharts =
        indicators.where((i) => i.displayMode == IndicatorDisplayMode.subChart);

    return Column(
      children: [
        // Main Chart with overlay
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              CandlesPainter(candles: prices), // افترضنا أنه يحوّل الأسعار لـ OHLC خطوط
              ...overlaySeries.map((ind) => IndicatorPainter(values: ind.values)),
            ],
          ),
        ),

        // Sub‑chart indicators
        Expanded(
          flex: 1,
          child: ListView(
            children: subCharts.map((ind) {
              return SizedBox(
                height: 120,
                child: IndicatorSubChartPainter(values: ind.values, label: ind.label),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
