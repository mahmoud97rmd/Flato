import 'package:flutter/material.dart';

class StopTakeInput extends StatelessWidget {
  final Function(double, double) onApply;

  StopTakeInput({required this.onApply});

  @override
  Widget build(BuildContext context) {
    double sl = 0, tp = 0;
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: "Stop Loss"),
          onChanged: (v) => sl = double.tryParse(v) ?? 0,
        ),
        TextField(
          decoration: InputDecoration(labelText: "Take Profit"),
          onChanged: (v) => tp = double.tryParse(v) ?? 0,
        ),
        ElevatedButton(
          child: Text("Apply"),
          onPressed: () => onApply(sl, tp),
        )
      ],
    );
  }
}
