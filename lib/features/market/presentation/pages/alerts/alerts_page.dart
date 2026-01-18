import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/alerts/alert_bloc.dart';
import '../../bloc/alerts/alert_state.dart';
import '../../bloc/alerts/alert_event.dart';
import '../../../domain/alerts/price_alert.dart';

class AlertsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Alerts"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              context.read<AlertBloc>().add(RemovePriceAlert(-1));
            },
          ),
        ],
      ),
      body: BlocBuilder<AlertBloc, AlertState>(
        builder: (context, state) {
          if (state is AlertUpdated) {
            final alerts = state.alerts;
            if (alerts.isEmpty) {
              return Center(child: Text("No alerts set"));
            }
            return ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (ctx, i) {
                final PriceAlert a = alerts[i];
                return ListTile(
                  title: Text("${a.symbol} @ ${a.price.toStringAsFixed(4)}"),
                  subtitle: Text(a.triggerAbove ? "Above" : "Below"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, a, i);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<AlertBloc>().add(RemovePriceAlert(i));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: Text("Loading alerts..."));
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, PriceAlert alert, int index) {
    final TextEditingController _priceCtrl =
        TextEditingController(text: alert.price.toString());
    bool triggerAbove = alert.triggerAbove;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Alert"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Target Price"),
            ),
            Row(
              children: [
                Text("Trigger when:"),
                Switch(
                  value: triggerAbove,
                  onChanged: (v) => triggerAbove = v,
                ),
                Text(triggerAbove ? "Above" : "Below"),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final double? newPrice = double.tryParse(_priceCtrl.text);
              if (newPrice != null) {
                // حذف القديم واضافة الجديد
                context.read<AlertBloc>().add(RemovePriceAlert(index));
                context.read<AlertBloc>().add(AddPriceAlert(
                      PriceAlert(
                        price: newPrice,
                        triggerAbove: triggerAbove,
                        symbol: alert.symbol,
                      ),
                    ));
              }
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
