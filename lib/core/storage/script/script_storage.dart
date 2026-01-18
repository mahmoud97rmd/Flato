import 'package:hive/hive.dart';
import 'script_hive.dart';

class ScriptStorage {
  static const _box = "scripts_box";

  Future<void> saveScript(ScriptEntity script) async {
    final box = await Hive.openBox<ScriptEntity>(_box);
    await box.put(script.name, script);
  }

  Future<ScriptEntity?> loadScript(String name) async {
    final box = await Hive.openBox<ScriptEntity>(_box);
    return box.get(name);
  }

  Future<List<ScriptEntity>> getAllScripts() async {
    final box = await Hive.openBox<ScriptEntity>(_box);
    return box.values.toList();
  }

  Future<void> deleteScript(String name) async {
    final box = await Hive.openBox<ScriptEntity>(_box);
    await box.delete(name);
  }
}
