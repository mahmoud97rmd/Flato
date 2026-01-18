import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CandleStick {
  final double x, open, high, low, close;
  CandleStick({
    required this.x,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

class CandleStickChart extends StatelessWidget {
  final List<CandleStick> data;

  CandleStickChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: data.map((c) {
          return BarChartGroupData(x: c.x.toInt(), barRods: [
            BarChartRodData(
              toY: c.high,
              fromY: c.low,
              color: c.close >= c.open ? Colors.green : Colors.red,
              width: 5,
            ),
          ]);
        }).toList(),
      ),
    );
  }
}
