import 'package:flutter/material.dart';
import '../../../domain/backtest/backtest_result.dart';

class BacktestReportWidget extends StatelessWidget {
  final BacktestResult result;

  BacktestReportWidget({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Net Profit: ${result.netProfit.toStringAsFixed(2)}"),
        Text("Win Rate: ${result.winRate.toStringAsFixed(2)}%"),
        Text("Max Drawdown: ${result.maxDrawdown.toStringAsFixed(2)}%"),
      ],
    );
  }
}
