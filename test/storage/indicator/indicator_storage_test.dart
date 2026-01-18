import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:your_app/core/storage/indicator/indicator_storage.dart';
import 'package:your_app/core/storage/indicator/indicator_hive.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.path);
    Hive.registerAdapter(IndicatorSettingsEntityAdapter());
  });

  test('save and load indicator settings', () async {
    final store = IndicatorSettingsStorage();
    final e = IndicatorSettingsEntity(id: "EMA10", params: {"color": 0xFF0000});
    await store.saveSettings(e);

    final loaded = await store.loadSettings("EMA10");
    expect(loaded?.params["color"], 0xFF0000);
  });
}
