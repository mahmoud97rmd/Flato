import '../../../domain/strategy/strategy_config.dart';

abstract class SettingsState {}

class SettingsIdle extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final StrategyConfig config;
  SettingsLoaded(this.config);
}

class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message);
}
