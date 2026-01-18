import 'package:hive/hive.dart';
import 'theme_hive.dart';

class ThemeStorage {
  static const _box = "theme_box";

  Future<void> saveTheme(ThemeEntity theme) async {
    final box = await Hive.openBox<ThemeEntity>(_box);
    await box.put('current', theme);
  }

  Future<ThemeEntity?> loadTheme() async {
    final box = await Hive.openBox<ThemeEntity>(_box);
    return box.get('current');
  }

  Future<void> clear() async {
    final box = await Hive.openBox<ThemeEntity>(_box);
    await box.clear();
  }
}
