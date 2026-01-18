import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:candlesticks/candlesticks.dart';

import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_event.dart';
import '../bloc/chart/chart_state.dart';

class InteractiveChartPage extends StatelessWidget {
  final String symbol;

  InteractiveChartPage({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChartBloc(
        repository: RepositoryProvider.of(context),
        symbol: symbol,
        timeframe: "M1",
      )..add(LoadChartHistory(symbol: symbol, timeframe: "M1")),
      child: _InteractiveChartView(symbol: symbol),
    );
  }
}

class _InteractiveChartView extends StatefulWidget {
  final String symbol;
  _InteractiveChartView({required this.symbol});

  @override
  __InteractiveChartViewState createState() => __InteractiveChartViewState();
}

class __InteractiveChartViewState extends State<_InteractiveChartView> {
  List<Candle> _candleItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chart — ${widget.symbol}")),
      body: BlocBuilder<ChartBloc, ChartState>(
        builder: (context, state) {
          if (state is ChartLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ChartLoaded) {
            _candleItems = state.candles.map((c) => Candle(
              date: c.time,
              open: c.open,
              high: c.high,
              low: c.low,
              close: c.close,
              volume: c.volume.toDouble(),
            )).toList();

            return Column(
              children: [
                Expanded(
                  child: Candlesticks(
                    candles: _candleItems,
                    showVolume: true,
                    onIndicatorChange: (i) {},
                  ),
                ),
              ],
            );
          }
          if (state is ChartError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return Container();
        },
      ),
    );
  }
}

// داخل الـ AppBar:
actions: [
  IconButton(
    icon: Icon(Icons.show_chart),
    onPressed: () => context.read<DrawingBloc>().add(StartTrendline()),
  ),
  IconButton(
    icon: Icon(Icons.horizontal_rule),
    onPressed: () => context.read<DrawingBloc>().add(AddHorizontalLine(priceY: 0)),
  ),
],
