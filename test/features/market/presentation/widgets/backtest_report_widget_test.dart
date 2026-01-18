import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:your_app/features/market/presentation/widgets/backtest/backtest_report_widget.dart';
import 'package:your_app/features/market/domain/backtest/backtest_result.dart';

void main() {
  testWidgets('Backtest report displays numbers', (tester) async {
    final result = BacktestResult(
      timestamps: [DateTime.now()],
      equityCurve: [10000],
      netProfit: 100,
      maxDrawdown: 5,
      winRate: 50,
    );
    await tester.pumpWidget(MaterialApp(
      home: BacktestReportWidget(result: result),
    ));
    expect(find.textContaining("Net Profit"), findsOneWidget);
  });
}
