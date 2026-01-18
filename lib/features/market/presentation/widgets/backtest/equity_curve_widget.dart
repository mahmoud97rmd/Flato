import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../domain/backtest/backtest_result.dart';

class EquityCurveWidget extends StatelessWidget {
  final BacktestResult result;

  EquityCurveWidget({required this.result});

  @override
  Widget build(BuildContext context) {
    final spots = result.equityCurve.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(spots: spots, isCurved: true, colors: [Colors.blue]),
        ],
      ),
    );
  }
}
