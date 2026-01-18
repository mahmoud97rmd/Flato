abstract class SettingsEvent {}

/// تحميل الإعدادات الحالية
class LoadSettingsEvent extends SettingsEvent {}

/// تحديث إعدادات الاستراتيجية
class UpdateStrategySettings extends SettingsEvent {
  final int emaShort;
  final int emaLong;
  final int stochPeriod;
  final int stochSmoothK;
  final int stochSmoothD;
  final double stopLossPct;
  final double takeProfitPct;

  UpdateStrategySettings({
    required this.emaShort,
    required this.emaLong,
    required this.stochPeriod,
    required this.stochSmoothK,
    required this.stochSmoothD,
    required this.stopLossPct,
    required this.takeProfitPct,
  });
}
