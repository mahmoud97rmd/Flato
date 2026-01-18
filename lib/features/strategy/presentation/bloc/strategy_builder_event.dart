abstract class StrategyBuilderEvent {}

class AddBlock extends StrategyBuilderEvent {
  final String id;
  final String type;
  final Map<String, dynamic> params;

  AddBlock({
    required this.id,
    required this.type,
    required this.params,
  });
}

class RemoveBlock extends StrategyBuilderEvent {
  final String id;
  RemoveBlock(this.id);
}

class ConnectBlocks extends StrategyBuilderEvent {
  final String fromId;
  final String toId;

  ConnectBlocks({required this.fromId, required this.toId});
}

class UpdateBlockParams extends StrategyBuilderEvent {
  final String id;
  final Map<String, dynamic> params;

  UpdateBlockParams({required this.id, required this.params});
}

class LoadStrategyGraph extends StrategyBuilderEvent {
  final String graphId;
  LoadStrategyGraph(this.graphId);
}

class SaveStrategyGraph extends StrategyBuilderEvent {
  final String graphId;
  SaveStrategyGraph(this.graphId);
}
