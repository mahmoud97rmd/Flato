import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/analytics/analytics_bloc.dart';
import '../../bloc/analytics/analytics_event.dart';
import '../../bloc/analytics/analytics_state.dart';

class AnalyticsPage extends StatelessWidget {
  final List<double> profits;
  AnalyticsPage({required this.profits});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Advanced Analytics")),
      body: BlocProvider(
        create: (_) => AnalyticsBloc()..add(ComputeAnalytics(profits)),
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is AnalyticsLoaded) {
              final r = state.result;
              return ListView(
                padding: EdgeInsets.all(12),
                children: [
                  Text("Net Profit: ${r.netProfit.toStringAsFixed(2)}"),
                  Text("Win Rate: ${r.winRate.toStringAsFixed(2)}%"),
                  Text("Sharp Ratio: ${r.sharpRatio.toStringAsFixed(2)}"),
                  Text("Expectancy: ${r.expectancy.toStringAsFixed(2)}"),
                  Text("Total Trades: ${r.totalTrades}"),
                  Text("Wins: ${r.wins}"),
                  Text("Losses: ${r.losses}"),
                ],
              );
            }
            if (state is AnalyticsError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
