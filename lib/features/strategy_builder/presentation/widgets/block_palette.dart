import 'package:flutter/material.dart';
import '../../domain/entities/block_type.dart';

class BlockPalette extends StatelessWidget {
  final Function(BlockType) onDragStart;

  const BlockPalette({required this.onDragStart});

  @override
  Widget build(BuildContext context) {
    final blocks = {
      "Price Above": BlockType.priceAbove,
      "Price Below": BlockType.priceBelow,
      "EMA Cross Up": BlockType.emaCrossUp,
      "EMA Cross Down": BlockType.emaCrossDown,
      "RSI Below": BlockType.rsiBelow,
      "RSI Above": BlockType.rsiAbove,
      "AND": BlockType.and,
      "OR": BlockType.or,
      "BUY": BlockType.buy,
      "SELL": BlockType.sell,
    };

    return Container(
      width: 180,
      color: Colors.grey.shade900,
      child: ListView(
        children: blocks.entries.map((e) {
          return Draggable<BlockType>(
            data: e.value,
            feedback: _buildBlock(e.key, Colors.blueAccent),
            child: _buildBlock(e.key, Colors.white),
            onDragStarted: () => onDragStart(e.value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBlock(String label, Color color) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(label, style: TextStyle(color: color))),
    );
  }
}
