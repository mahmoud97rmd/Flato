import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/market_repository.dart';
import '../../../data/models/position/position_model.dart';
import 'positions_event.dart';
import 'positions_state.dart';

class PositionsBloc extends Bloc<PositionsEvent, PositionsState> {
  final MarketRepository repository;

  PositionsBloc(this.repository) : super(PositionsIdle()) {
    on<LoadPositions>(_onLoad);
    on<ClosePositionEvent>(_onClose);
    on<ModifyPositionEvent>(_onModify);
  }

  Future<void> _onLoad(LoadPositions event, Emitter<PositionsState> emit) async {
    emit(PositionsLoading());
    try {
      final res = await repository.getOpenPositions();
      final positionsJson = res["positions"] as List<dynamic>;
      final list = positionsJson
          .map((e) => PositionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      emit(PositionsLoaded(list));
    } catch (e) {
      emit(PositionsError("Failed to load positions"));
    }
  }

  Future<void> _onClose(ClosePositionEvent event, Emitter<PositionsState> emit) async {
    emit(PositionsLoading());
    try {
      await repository.closePosition(event.instrument);
      add(LoadPositions());
    } catch (e) {
      emit(PositionsError("Failed to close position"));
    }
  }

  Future<void> _onModify(ModifyPositionEvent event, Emitter<PositionsState> emit) async {
    emit(PositionsLoading());
    try {
      final body = {
        "stopLoss": {"price": event.stopLoss.toString()},
        "takeProfit": {"price": event.takeProfit.toString()},
      };
      await repository.modifyPosition(event.instrument, body);
      add(LoadPositions());
    } catch (e) {
      emit(PositionsError("Failed to modify position"));
    }
  }
}
