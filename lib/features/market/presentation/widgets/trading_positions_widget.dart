import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/trading/trading_bloc.dart';
import '../bloc/trading/trading_state.dart';

class TradingPositionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradingBloc, TradingState>(
      builder: (context, state) {
        if (state is TradingUpdated) {
          return ListView(
            children: [
              ...state.openPositions.map((p) => ListTile(
                title: Text("${p.instrument}: ${p.type}"),
                subtitle: Text("Entry: ${p.entryPrice}"),
              )),
              Divider(),
              ...state.tradeHistory.map((h) => ListTile(
                title: Text("Closed: ${h.profit.toStringAsFixed(2)}"),
              )),
            ],
          );
        }
        return Text("No trades yet");
      },
    );
  }
}
