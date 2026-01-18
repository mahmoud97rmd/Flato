import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/chart_indicators/integrated_indicators.dart';
import '../../../domain/entities/candle.dart';
import '../../bloc/live_chart/live_chart_bloc.dart';
import '../../bloc/live_chart/live_chart_state.dart';

class InteractiveChartPage extends StatefulWidget {
  final String symbol;
  const InteractiveChartPage({required this.symbol});

  @override
  _InteractiveChartPageState createState() => _InteractiveChartPageState();
}

class _InteractiveChartPageState extends State<InteractiveChartPage> {
  final IndicatorManager _indicatorManager = IndicatorManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.symbol)),
      body: Column(
        children: [
          // زرّ إضافة المؤشرات
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      setState(() => _indicatorManager.add(EMAIndicator(14))),
                  child: Text("EMA(14)"),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => _indicatorManager.add(RSIIndicator(14))),
                  child: Text("RSI(14)"),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => _indicatorManager.add(MACDIndicator())),
                  child: Text("MACD"),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => setState(() => _indicatorManager.clear()),
                  child: Text("Clear All"),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<LiveChartBloc, LiveChartState>(
              builder: (context, state) {
                List<Candle> candles = [];
                if (state is LiveChartLoaded) {
                  candles = state.candles;
                }

                return CustomPaint(
                  size: Size.infinite,
                  painter: IndicatorPainter(
                    candles,
                    _indicatorManager.all,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
