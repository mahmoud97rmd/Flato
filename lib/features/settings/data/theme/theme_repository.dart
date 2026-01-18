import 'package:hive/hive.dart';
import '../../domain/theme/app_theme.dart';

class ThemeRepository {
  static const String _boxName = "app_theme";

  Future<void> init() async {
    await Hive.openBox<Map>(_boxName);
  }

  Future<void> saveTheme(AppTheme theme) async {
    final box = Hive.box<Map>(_boxName);
    await box.put("current", theme.toJson());
  }

  AppTheme loadTheme() {
    final box = Hive.box<Map>(_boxName);
    final data = box.get("current");
    if (data == null) return AppTheme.defaultLight();
    return AppTheme.fromJson(Map<String, dynamic>.from(data));
  }
}
