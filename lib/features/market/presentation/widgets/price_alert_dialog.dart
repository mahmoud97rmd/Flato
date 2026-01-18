import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/alerts/alert_bloc.dart';
import '../bloc/alerts/alert_event.dart';
import '../../domain/alerts/price_alert.dart';

class PriceAlertDialog extends StatefulWidget {
  final String symbol;
  PriceAlertDialog({required this.symbol});

  @override
  _PriceAlertDialogState createState() => _PriceAlertDialogState();
}

class _PriceAlertDialogState extends State<PriceAlertDialog> {
  final TextEditingController _priceCtrl = TextEditingController();
  bool triggerAbove = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Price Alert"),
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
                onChanged: (v) => setState(() => triggerAbove = v),
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
            final price = double.tryParse(_priceCtrl.text);
            if (price != null) {
              context.read<AlertBloc>().add(
                    AddPriceAlert(
                      PriceAlert(
                        price: price,
                        triggerAbove: triggerAbove,
                        symbol: widget.symbol,
                      ),
                    ),
                  );
              Navigator.pop(context);
            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
