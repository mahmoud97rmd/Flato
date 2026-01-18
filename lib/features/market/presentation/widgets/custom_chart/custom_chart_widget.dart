import 'package:flutter/material.dart';
import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_state.dart';
import 'candles_painter.dart';
import 'indicator_painter.dart';
import 'drawing_painter.dart';

class CustomChartWidget extends StatelessWidget {
  final ChartState state;
  final List<List<Offset>> trendlines;
  final List<double> horizontalLines;

  CustomChartWidget({
    required this.state,
    required this.trendlines,
    required this.horizontalLines,
  });

  @override
  Widget build(BuildContext context) {
    if (state is ChartLoaded) {
      final candles = (state as ChartLoaded).candles;

      // بناء نقاط خطوط المؤشرات
      final ema50 = List<Offset>.generate(
        candles.length,
        (i) => Offset(i.toDouble(), (state as ChartLoaded).indicators[0].values[i]),
      );
      final ema200 = List<Offset>.generate(
        candles.length,
        (i) => Offset(i.toDouble(), (state as ChartLoaded).indicators[1].values[i]),
      );

      return LayoutBuilder(builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: CandlesPainter(candles: candles),
          foregroundPainter: DrawingPainter(
            trendlines: trendlines,
            horizontalLines: horizontalLines,
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: IndicatorPainter(linePoints: ema50, color: Colors.blue),
              ),
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: IndicatorPainter(linePoints: ema200, color: Colors.orange),
              ),
            ],
          ),
        );
      });
    }
    return Container();
  }
}
