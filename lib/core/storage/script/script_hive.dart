import 'package:hive/hive.dart';

part 'script_hive.g.dart';

@HiveType(typeId: 11)
class ScriptEntity extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String script;

  ScriptEntity({required this.name, required this.script});
}
