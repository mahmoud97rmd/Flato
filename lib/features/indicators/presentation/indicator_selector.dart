import 'package:flutter/material.dart';

class IndicatorSelector extends StatelessWidget {
  final Function(String) onSelect;

  IndicatorSelector({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final indicators = ["EMA", "RSI", "Stochastic", "MACD"];

    return BottomSheet(
      onClosing: () {},
      builder: (ctx) => ListView(
        children: indicators.map((ind) => ListTile(
          title: Text(ind),
          onTap: () => onSelect(ind),
        )).toList(),
      ),
    );
  }
}
