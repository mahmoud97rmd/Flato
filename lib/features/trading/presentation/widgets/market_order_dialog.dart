import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/trading_bloc.dart';

class MarketOrderDialog extends StatefulWidget {
  final String symbol;
  MarketOrderDialog({required this.symbol});

  @override
  _MarketOrderDialogState createState() => _MarketOrderDialogState();
}

class _MarketOrderDialogState extends State<MarketOrderDialog> {
  final _unitsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Market Order: \${widget.symbol}"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _unitsCtrl,
          decoration: InputDecoration(labelText: "Units"),
          keyboardType: TextInputType.number,
        ),
      ]),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text("Place"),
          onPressed: () {
            final units = int.tryParse(_unitsCtrl.text) ?? 0;
            context.read<TradingBloc>().add(
                  PlaceMarketOrder(symbol: widget.symbol, units: units),
                );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
