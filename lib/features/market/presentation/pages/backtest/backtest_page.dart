import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/backtest/backtest_bloc.dart';
import '../../bloc/backtest/backtest_event.dart';
import '../../bloc/backtest/backtest_state.dart';

class BacktestPage extends StatelessWidget {
  final String symbol;

  BacktestPage({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Backtest — $symbol")),
      body: Column(
        children: [
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              context.read<BacktestBloc>().add(
                    RunBacktestEvent(
                      symbol: symbol,
                      timeframe: "M1",
                      start: null,
                      end: null,
                    ),
                  );
            },
            child: Text("Start Backtest"),
          ),
          SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<BacktestBloc, BacktestState>(
              builder: (context, state) {
                if (state is BacktestRunning) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is BacktestSuccess) {
                  final result = state.result;
                  return Column(
                    children: [
                      Text("Net Profit: ${result.netProfit.toStringAsFixed(2)}"),
                      Text("Win Rate: ${result.winRate.toStringAsFixed(2)}%"),
                      Text("Max Drawdown: ${result.maxDrawdown.toStringAsFixed(2)}"),
                      Expanded(
                        child: ListView.builder(
                          itemCount: result.equityCurve.length,
                          itemBuilder: (ctx, i) {
                            return ListTile(
                              title: Text(result.timestamps[i].toIso8601String()),
                              trailing: Text(result.equityCurve[i].toStringAsFixed(2)),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                if (state is BacktestError) {
                  return Center(
                    child: Text("Error: ${state.message}"),
                  );
                }
                return Center(child: Text("Press Start to Run Backtest"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
