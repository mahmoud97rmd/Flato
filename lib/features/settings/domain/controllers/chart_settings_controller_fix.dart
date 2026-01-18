import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ChartSettingsControllerFix {
  final List<Map<String, dynamic>> _undoStack = [];
  final List<Map<String, dynamic>> _redoStack = [];

  Future<void> save(Map<String, dynamic> cfg) async {
    final prefs = await SharedPreferences.getInstance();
    final backup = await load();
    if (backup != null) _undoStack.add(backup);

    await prefs.setString('chart_settings', cfg.toString());
  }

  Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString('chart_settings');
    if (str == null) return null;
    return Map<String, dynamic>.from({});
  }

  Future<void> undo() async {
    if (_undoStack.isEmpty) return;
    final last = _undoStack.removeLast();
    _redoStack.add(last);
    await save(last);
  }

  Future<void> redo() async {
    if (_redoStack.isEmpty) return;
    final last = _redoStack.removeLast();
    _undoStack.add(last);
    await save(last);
  }
}
