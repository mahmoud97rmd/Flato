import 'package:flutter/material.dart';
import '../../../market/presentation/bloc/trading/trading_bloc.dart';
import '../../../market/presentation/bloc/trading/trading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPortraitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradingBloc, TradingState>(
      builder: (context, state) {
        if (state is TradingUpdated) {
          return ListView(
            padding: EdgeInsets.all(12),
            children: state.openPositions.map((p) {
              return ListTile(
                title: Text("${p.instrument} — ${p.units.toString()}"),
                subtitle: Text("P/L: ${p.floatingPL.toStringAsFixed(2)}"),
              );
            }).toList(),
          );
        }
        return Center(child: Text("No Positions"));
      },
    );
  }
}
