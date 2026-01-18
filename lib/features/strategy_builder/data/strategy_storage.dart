import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/strategy_graph.dart';

class StrategyStorage {
  static const _key = "saved_strategy";

  Future<void> save(StrategyGraph graph) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(graph.toJson()));
  }

  Future<StrategyGraph?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return null;
    return StrategyGraph.fromJson(jsonDecode(data));
  }
}
