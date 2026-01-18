import 'package:flutter/material.dart';

class TradeActionButton extends StatelessWidget {
  final String action;
  final VoidCallback onTap;

  TradeActionButton({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isBuy = action.toUpperCase() == "BUY";
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isBuy ? Colors.green : Colors.red,
      ),
      child: Text(action),
      onPressed: onTap,
    );
  }
}
