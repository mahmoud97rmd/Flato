import 'package:hive/hive.dart';
import 'indicator_hive.dart';

class IndicatorSettingsStorage {
  static const _box = "indicator_box";

  Future<void> saveSettings(IndicatorSettingsEntity e) async {
    final box = await Hive.openBox<IndicatorSettingsEntity>(_box);
    await box.put(e.id, e);
  }

  Future<IndicatorSettingsEntity?> loadSettings(String id) async {
    final box = await Hive.openBox<IndicatorSettingsEntity>(_box);
    return box.get(id);
  }

  Future<List<IndicatorSettingsEntity>> getAll() async {
    final box = await Hive.openBox<IndicatorSettingsEntity>(_box);
    return box.values.toList();
  }
}
