import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/positions/positions_bloc.dart';
import '../../bloc/positions/positions_event.dart';
import '../../bloc/positions/positions_state.dart';
import '../../../data/models/position/position_model.dart';

class PositionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Open Positions")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.read<PositionsBloc>().add(LoadPositions()),
            child: Text("Refresh"),
          ),
          Expanded(
            child: BlocBuilder<PositionsBloc, PositionsState>(
              builder: (context, state) {
                if (state is PositionsLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is PositionsLoaded) {
                  final positions = state.positionList;
                  if (positions.isEmpty) {
                    return Center(child: Text("No open positions"));
                  }
                  return ListView.builder(
                    itemCount: positions.length,
                    itemBuilder: (ctx, i) {
                      final PositionModel p = positions[i];
                      return ListTile(
                        title: Text("${p.instrument} - Units: ${p.units.toString()}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Avg Price: ${p.averagePrice.toStringAsFixed(4)}"),
                            Text("Unrealized P/L: ${p.unrealizedPL.toStringAsFixed(2)}"),
                            Text("SL: ${p.stopLoss?.toStringAsFixed(4) ?? '-'}"),
                            Text("TP: ${p.takeProfit?.toStringAsFixed(4) ?? '-'}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showModifyDialog(context, p),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => context.read<PositionsBloc>().add(ClosePositionEvent(p.instrument)),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                if (state is PositionsError) {
                  return Center(child: Text("Error: ${state.message}"));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showModifyDialog(BuildContext context, PositionModel p) {
    final stopCtrl = TextEditingController(text: p.stopLoss?.toStringAsFixed(4) ?? '');
    final tpCtrl = TextEditingController(text: p.takeProfit?.toStringAsFixed(4) ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Modify Position"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stopCtrl,
              decoration: InputDecoration(labelText: "Stop Loss"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: tpCtrl,
              decoration: InputDecoration(labelText: "Take Profit"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final sl = double.tryParse(stopCtrl.text) ?? 0.0;
              final tp = double.tryParse(tpCtrl.text) ?? 0.0;
              context.read<PositionsBloc>().add(ModifyPositionEvent(
                instrument: p.instrument,
                stopLoss: sl,
                takeProfit: tp,
              ));
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
