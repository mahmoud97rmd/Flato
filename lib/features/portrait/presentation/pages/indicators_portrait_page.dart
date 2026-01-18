import 'package:flutter/material.dart';
import '../../../market/presentation/bloc/chart/chart_bloc.dart';
import '../../../market/presentation/bloc/chart/chart_state.dart';
import '../../../market/presentation/widgets/custom_chart/multi_indicator_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndicatorsPortraitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Indicators", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Expanded(
          child: BlocBuilder<ChartBloc, ChartState>(
            builder: (context, state) {
              if (state is ChartLoaded) {
                return MultiIndicatorChart(
                  prices: state.candles.map((c) => c.close).toList(),
                  indicators: state.indicators,
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
