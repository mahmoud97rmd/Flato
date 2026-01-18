import '../entities/block.dart';
import '../entities/block_type.dart';
import '../models/strategy_graph.dart';
import '../../../market/domain/entities/candle.dart';

class StrategyInterpreter {
  final StrategyGraph graph;

  StrategyInterpreter(this.graph);

  bool evaluate(List<CandleEntity> history) {
    final Map<String, bool> results = {};

    for (var block in graph.blocks) {
      results[block.id] = _evalBlock(block, history, results);
    }

    // Find final BUY/SELL blocks
    final buyBlocks =
        graph.blocks.where((b) => b.type == BlockType.buy).toList();
    for (var b in buyBlocks) {
      final incoming = graph.connections
          .where((c) => c.toBlockId == b.id)
          .map((c) => results[c.fromBlockId] ?? false)
          .toList();

      if (incoming.every((v) => v == true)) return true;
    }

    return false;
  }

  bool _evalBlock(Block b, List<CandleEntity> history, Map<String, bool> results) {
    switch (b.type) {
      case BlockType.priceAbove:
        return history.last.close >
            history[history.length - 2].close;

      case BlockType.rsiBelow:
        return b.params["value"] != null
            ? history.last.close < b.params["value"]
            : true;

      case BlockType.and:
        final inputs = graph.connections
            .where((c) => c.toBlockId == b.id)
            .map((c) => results[c.fromBlockId] ?? false)
            .toList();
        return inputs.every((v) => v);

      case BlockType.or:
        final inputs = graph.connections
            .where((c) => c.toBlockId == b.id)
            .map((c) => results[c.fromBlockId] ?? false)
            .toList();
        return inputs.any((v) => v);

      default:
        return false;
    }
  }
}
