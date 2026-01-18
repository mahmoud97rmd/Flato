import 'package:flutter/material.dart';
import '../../domain/entities/block.dart';
import '../../domain/entities/block_type.dart';

class StrategyNode extends StatelessWidget {
  final Block block;
  final Offset position;

  const StrategyNode({required this.block, required this.position});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Container(
        width: 180,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 1)
          ],
        ),
        child: Column(
          children: [
            Text(
              block.type.toString().split('.').last,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildPorts(),
          ],
        ),
      ),
    );
  }

  Widget _buildPorts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _port(Icons.input, Colors.green),  // input port
        _port(Icons.output, Colors.red),   // output port
      ],
    );
  }

  Widget _port(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color),
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }
}
