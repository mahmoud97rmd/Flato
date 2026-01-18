import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/trading_real/trading_real_bloc.dart';
import '../../bloc/trading_real/trading_real_event.dart';
import '../../../domain/trading/orders/order_request.dart';

class RealTradeDialog extends StatefulWidget {
  final String symbol;
  RealTradeDialog({required this.symbol});

  @override
  _RealTradeDialogState createState() => _RealTradeDialogState();
}

class _RealTradeDialogState extends State<RealTradeDialog> {
  final TextEditingController _unitsCtrl = TextEditingController();
  String _type = "MARKET";
  final priceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Place Real Order"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _unitsCtrl,
            decoration: InputDecoration(labelText: "Units (+ buy, - sell)"),
            keyboardType: TextInputType.number,
          ),
          DropdownButton<String>(
            value: _type,
            items: ["MARKET", "LIMIT", "STOP"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _type = v!),
          ),
          if (_type != "MARKET")
            TextField(
              controller: priceCtrl,
              decoration: InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final units = int.tryParse(_unitsCtrl.text) ?? 0;
            final price = _type == "MARKET"
                ? null
                : double.tryParse(priceCtrl.text);
            final request = OrderRequest(
              instrument: widget.symbol,
              units: units,
              type: _type,
              price: price,
            );
            context.read<TradingRealBloc>().add(SubmitRealOrder(request));
            Navigator.pop(context);
          },
          child: Text("Submit"),
        ),
      ],
    );
  }
}
