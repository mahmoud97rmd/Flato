import 'package:flutter/material.dart';
import '../storage/preferences.dart';
import '../storage/indicator/indicator_settings_storage.dart';

class AppInitializer {
  static Future<void> init() async {
    final isDark = await UserPreferences.loadTheme();
    // إعداد الثيم
    // تحميل إعدادات المؤشرات
  }
}
