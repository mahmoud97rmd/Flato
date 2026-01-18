import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../domain/strategy/strategy_config.dart';
import '../../data/storage/settings_storage.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  final SettingsStorage _storage = SettingsStorage();

  SettingsBloc() : super(SettingsIdle()) {
    on<LoadSettingsEvent>(_onLoad);
    on<UpdateStrategySettings>(_onUpdate);
  }

  Future<void> _onLoad(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final settings = _storage.getStrategySettings() ??
          StrategyConfig(
            emaShort: 50,
            emaLong: 200,
            stochPeriod: 14,
            stochSmoothK: 3,
            stochSmoothD: 3,
            stopLossPct: 0.002,
            takeProfitPct: 0.005,
            minSignalIntervalSeconds: 60,
          );

      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError("Failed to load settings"));
    }
  }

  Future<void> _onUpdate(
    UpdateStrategySettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final config = StrategyConfig(
        emaShort: event.emaShort,
        emaLong: event.emaLong,
        stochPeriod: event.stochPeriod,
        stochSmoothK: event.stochSmoothK,
        stochSmoothD: event.stochSmoothD,
        stopLossPct: event.stopLossPct,
        takeProfitPct: event.takeProfitPct,
        minSignalIntervalSeconds: 60,
      );

      await _storage.saveStrategySettings(config);
      emit(SettingsLoaded(config));
    } catch (e) {
      emit(SettingsError("Failed to update settings"));
    }
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      final config = StrategyConfig.fromJson(
        Map<String, dynamic>.from(json['config']),
      );
      return SettingsLoaded(config);
    } catch (_) {}
    return SettingsIdle();
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    if (state is SettingsLoaded) {
      return {'config': state.config.toJson()};
    }
    return null;
  }
}
