import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_event.dart';
import '../bloc/chart/chart_state.dart';
import '../widgets/candlestick_chart_real.dart';

class MarketChartPage extends StatelessWidget {
  final String symbol;

  MarketChartPage({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChartBloc(
        repository: RepositoryProvider.of(context),
        symbol: symbol,
        timeframe: "M1",
      )..add(LoadChartHistory(symbol: symbol, timeframe: "M1")),
      child: Scaffold(
        appBar: AppBar(title: Text("Chart — $symbol")),
        body: BlocBuilder<ChartBloc, ChartState>(
          builder: (context, state) {
            if (state is ChartLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ChartLoaded) {
              return ListView(
                children: [
                  RealCandleStickChart(candles: state.candles),
                ],
              );
            }
            if (state is ChartError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
