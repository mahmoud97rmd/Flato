import 'package:flutter/material.dart';
import '../../domain/entities/block.dart';
import '../../domain/entities/block_type.dart';
import '../../domain/entities/connection.dart';
import 'node_widget.dart';

class StrategyCanvas extends StatefulWidget {
  final List<Block> blocks;
  final List<Connection> connections;
  final Function(Block, Offset) onDrop;

  const StrategyCanvas({
    required this.blocks,
    required this.connections,
    required this.onDrop,
  });

  @override
  State<StrategyCanvas> createState() => _StrategyCanvasState();
}

class _StrategyCanvasState extends State<StrategyCanvas> {
  final Map<String, Offset> nodePositions = {};

  @override
  Widget build(BuildContext context) {
    return DragTarget<BlockType>(
      onAcceptWithDetails: (details) {
        final position = details.offset;
        final newBlock = Block(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: details.data,
        );
        widget.onDrop(newBlock, position);
        nodePositions[newBlock.id] = position;
      },
      builder: (context, candidateData, rejectedData) {
        return Stack(
          children: [
            Container(color: Colors.grey.shade800),
            ...widget.blocks.map((b) {
              final pos = nodePositions[b.id] ?? Offset(100, 100);
              return StrategyNode(block: b, position: pos);
            }).toList(),
          ],
        );
      },
    );
  }
}
