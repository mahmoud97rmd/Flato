import 'package:flutter/material.dart';

class CrosshairOverlay extends StatelessWidget {
  final Offset position;
  CrosshairOverlay({required this.position});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: 0,
          bottom: 0,
          child: Container(width: 1, color: Colors.grey),
        ),
        Positioned(
          top: position.dy,
          left: 0,
          right: 0,
          child: Container(height: 1, color: Colors.grey),
        ),
      ],
    );
  }
}
