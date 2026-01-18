import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:your_app/core/storage/theme/theme_storage.dart';
import 'package:your_app/core/storage/theme/theme_hive.dart';
import 'dart:io';

class FakePathProvider extends Fake implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }
}

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.path);
    Hive.registerAdapter(ThemeEntityAdapter());
  });

  test('save and load theme', () async {
    final store = ThemeStorage();
    final theme = ThemeEntity(isDark: true, primaryColorValue: 0xFF0000, accentColorValue: 0x00FF00);
    await store.saveTheme(theme);

    final loaded = await store.loadTheme();
    expect(loaded?.isDark, true);
    expect(loaded?.primaryColorValue, theme.primaryColorValue);
  });
}
