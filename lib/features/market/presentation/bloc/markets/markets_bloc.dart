import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'markets_event.dart';
import 'markets_state.dart';
import '../../../data/repositories/market_repository_impl.dart';
import '../../../data/datasources/local_storage.dart';

class MarketsBloc extends HydratedBloc<MarketsEvent, MarketsState> {
  final MarketRepositoryImpl repository;
  final LocalStorage storage;

  MarketsBloc({
    required this.repository,
    required this.storage,
  }) : super(MarketsIdle()) {
    on<LoadMarkets>(_onLoadMarkets);
  }

  Future<void> _onLoadMarkets(
    LoadMarkets event,
    Emitter<MarketsState> emit,
  ) async {
    emit(MarketsLoading());

    try {
      final list = await repository.fetchAvailableInstruments();

      // Auto‑filter to FX + Metals
      final filtered = list.where((symbol) {
        final s = symbol.toLowerCase();
        return s.contains("usd") || s.contains("xau") || s.contains("xag");
      }).toList();

      if (filtered.isEmpty) {
        emit(MarketsEmpty());
      } else {
        emit(MarketsLoaded(filtered));
      }
    } catch (e) {
      emit(MarketsError("Failed to load markets"));
    }
  }

  @override
  MarketsState? fromJson(Map<String, dynamic> json) {
    final list = (json['instruments'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList();
    if (list != null && list.isNotEmpty) {
      return MarketsLoaded(list);
    }
    return MarketsIdle();
  }

  @override
  Map<String, dynamic>? toJson(MarketsState state) {
    if (state is MarketsLoaded) {
      return {
        "instruments": state.instruments,
      };
    }
    return null;
  }
}
