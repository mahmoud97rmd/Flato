import 'package:flutter/material.dart';

class SignalMarker extends StatelessWidget {
  final bool isBuy;
  final Offset position;
  final String label;

  SignalMarker({
    required this.isBuy,
    required this.position,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Column(
        children: [
          Icon(
            isBuy ? Icons.arrow_circle_up : Icons.arrow_circle_down,
            color: isBuy ? Colors.green : Colors.red,
            size: 28,
          ),
          Text(label),
        ],
      ),
    );
  }
}
