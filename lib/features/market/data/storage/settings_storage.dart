import 'package:hive/hive.dart';
import 'strategy_settings.dart';

class SettingsStorage {
  final Box _box = Hive.box('settings');

  Future<void> saveStrategySettings(StrategySettings settings) async {
    await _box.put('strategy_settings', settings.toJson());
  }

  StrategySettings? getStrategySettings() {
    final json = _box.get('strategy_settings');
    if (json == null) return null;
    return StrategySettings.fromJson(Map<String, dynamic>.from(json));
  }
}
