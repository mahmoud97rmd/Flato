import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/ui/widgets/loading_widget.dart';
import '../widgets/chart_webview.dart';
import '../../presentation/bloc/live_chart/live_chart_bloc.dart';

class ChartPage extends StatefulWidget {
  final String symbol;
  const ChartPage({required this.symbol});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String _timeframe = "M1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chart: \${widget.symbol}"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (tf) {
              setState(() => _timeframe = tf);
              context.read<LiveChartBloc>().add(LoadLiveCandlesRequest(
                    widget.symbol,
                    tf,
                  ));
            },
            itemBuilder: (c) => [
              "M1",
              "M5",
              "M15",
              "H1",
            ].map((tf) => PopupMenuItem(
                  value: tf,
                  child: Text(tf),
                )).toList(),
          ),
        ],
      ),
      body: BlocBuilder<LiveChartBloc, LiveChartState>(
        builder: (c, state) {
          if (state is LiveChartLoading)
            return LoadingWidget(message: "Loading Candles...");
          if (state is LiveChartLoaded)
            return ChartWebView(
              candles: state.candles,
              emaShort: state.emaShort,
              emaLong: state.emaLong,
              rsi: state.rsi,
            );
          return ErrorScreen("Failed to load chart");
        },
      ),
    );
  }
}
