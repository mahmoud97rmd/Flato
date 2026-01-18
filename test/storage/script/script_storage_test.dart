import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:your_app/core/storage/script/script_storage.dart';
import 'package:your_app/core/storage/script/script_hive.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.path);
    Hive.registerAdapter(ScriptEntityAdapter());
  });

  test('save and load script', () async {
    final storage = ScriptStorage();
    final script = ScriptEntity(name: "Test1", script: "EMA(10)>EMA(20)");
    await storage.saveScript(script);

    final loaded = await storage.loadScript("Test1");
    expect(loaded?.script, "EMA(10)>EMA(20)");
  });
}
