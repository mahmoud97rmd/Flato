import '../entities/block.dart';
import '../entities/connection.dart';

class StrategyGraph {
  final List<Block> blocks;
  final List<Connection> connections;

  StrategyGraph({required this.blocks, required this.connections});

  Map<String, dynamic> toJson() {
    return {
      "blocks": blocks.map((b) => {
            "id": b.id,
            "type": b.type.toString(),
            "params": b.params,
          }).toList(),
      "connections": connections
          .map((c) => {"from": c.fromBlockId, "to": c.toBlockId})
          .toList(),
    };
  }

  factory StrategyGraph.fromJson(Map<String, dynamic> json) {
    final blocks = (json["blocks"] as List<dynamic>)
        .map((b) => Block(
              id: b["id"],
              type: BlockType.values.firstWhere(
                  (e) => e.toString() == b["type"]),
              params: Map<String, dynamic>.from(b["params"] ?? {}),
            ))
        .toList();
    final connections = (json["connections"] as List<dynamic>)
        .map((c) => Connection(
              fromBlockId: c["from"],
              toBlockId: c["to"],
            ))
        .toList();
    return StrategyGraph(blocks: blocks, connections: connections);
  }
}
