import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/strategy_comparison/strategy_comparison_bloc.dart';
import '../../bloc/strategy_comparison/strategy_comparison_event.dart';
import '../../bloc/strategy_comparison/strategy_comparison_state.dart';

class StrategyComparisonPage extends StatelessWidget {
  final List history;
  final List configs;

  StrategyComparisonPage({
    required this.history,
    required this.configs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Strategy Comparison")),
      body: BlocProvider(
        create: (_) => StrategyComparisonBloc(),
        child: BlocBuilder<StrategyComparisonBloc, ComparisonState>(
          builder: (context, state) {
            if (state is ComparisonRunning)
              return Center(child: CircularProgressIndicator());

            if (state is ComparisonSuccess) {
              final results = state.results;
              return ListView(
                children: results.entries.map((e) {
                  final key = e.key;
                  final res = e.value;
                  return ListTile(
                    title: Text("Strategy: \$key"),
                    subtitle: Text("Net: \${res.netProfit} | WinRate: \${res.winRate}"),
                  );
                }).toList(),
              );
            }

            if (state is ComparisonError)
              return Center(child: Text(state.message));

            return Center(
              child: ElevatedButton(
                child: Text("Start Comparison"),
                onPressed: () {
                  final set = StrategySet(
                    strategies: configs.map((c) => StrategyInstance(id: c.id, config: c)).toList(),
                  );
                  context.read<StrategyComparisonBloc>().add(
                        RunComparison(set: set, history: history),
                      );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
