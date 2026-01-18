import 'package:flutter_bloc/flutter_bloc.dart';
import 'strategy_builder_event.dart';
import 'strategy_builder_state.dart';
import '../../../../core/storage/strategy/strategy_storage.dart';
import '../../../../core/models/strategy_graph.dart';

class StrategyBuilderBloc extends Bloc<StrategyBuilderEvent, StrategyBuilderState> {
  final StrategyStorage storage;

  StrategyBuilderBloc(this.storage) : super(BuilderInitial()) {
    on<AddBlock>(_onAddBlock);
    on<RemoveBlock>(_onRemoveBlock);
    on<ConnectBlocks>(_onConnect);
    on<UpdateBlockParams>(_onUpdateParams);
    on<LoadStrategyGraph>(_onLoad);
    on<SaveStrategyGraph>(_onSave);
  }

  StrategyGraph _current = StrategyGraph(blocks: [], connections: []);

  void _onAddBlock(AddBlock event, Emitter<StrategyBuilderState> emit) {
    _current.blocks.add(
      Block(id: event.id, type: event.type, params: event.params),
    );
    emit(BuilderLoaded(_current));
  }

  void _onRemoveBlock(RemoveBlock event, Emitter<StrategyBuilderState> emit) {
    _current.blocks.removeWhere((b) => b.id == event.id);
    _current.connections.removeWhere((c) => c.fromBlockId == event.id || c.toBlockId == event.id);
    emit(BuilderLoaded(_current));
  }

  void _onConnect(ConnectBlocks event, Emitter<StrategyBuilderState> emit) {
    _current.connections.add(Connection(fromBlockId: event.fromId, toBlockId: event.toId));
    emit(BuilderLoaded(_current));
  }

  void _onUpdateParams(UpdateBlockParams event, Emitter<StrategyBuilderState> emit) {
    final block = _current.blocks.firstWhere((b) => b.id == event.id);
    if (block != null) {
      block.params.addAll(event.params);
    }
    emit(BuilderLoaded(_current));
  }

  Future<void> _onLoad(LoadStrategyGraph event, Emitter<StrategyBuilderState> emit) async {
    try {
      final graph = await storage.load(event.graphId);
      _current = graph;
      emit(BuilderLoaded(graph));
    } catch (e) {
      emit(BuilderError(e.toString()));
    }
  }

  Future<void> _onSave(SaveStrategyGraph event, Emitter<StrategyBuilderState> emit) async {
    try {
      await storage.save(event.graphId, _current);
      emit(BuilderLoaded(_current));
    } catch (e) {
      emit(BuilderError(e.toString()));
    }
  }
}
