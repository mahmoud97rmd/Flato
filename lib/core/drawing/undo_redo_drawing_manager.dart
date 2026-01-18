import 'package:flutter/material.dart';

/// =================================================================
/// 1) Undo/Redo Stack Manager for Drawing Tools
/// =================================================================

class DrawingCommand {
  final String id;
  final dynamic data;

  DrawingCommand(this.id, this.data);
}

class UndoRedoManager {
  final List<DrawingCommand> _undoStack = [];
  final List<DrawingCommand> _redoStack = [];

  void execute(DrawingCommand command) {
    _undoStack.add(command);
    _redoStack.clear();
  }

  DrawingCommand? undo() {
    if (_undoStack.isEmpty) return null;

    final last = _undoStack.removeLast();
    _redoStack.add(last);
    return last;
  }

  DrawingCommand? redo() {
    if (_redoStack.isEmpty) return null;
    final cmd = _redoStack.removeLast();
    _undoStack.add(cmd);
    return cmd;
  }

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
}

/// =================================================================
/// 2) Controller Helper to Integrate with Widgets
/// =================================================================

class DrawingController {
  final UndoRedoManager manager = UndoRedoManager();
  // Last drawn objects cache
  final List<Offset> trendPoints = [];

  void addTrendLine(Offset a, Offset b) {
    final data = {'type': 'trend', 'a': a, 'b': b};
    manager.execute(DrawingCommand("trend_line", data));
    trendPoints.addAll([a, b]);
  }

  Offset? undoTrendLine() {
    final cmd = manager.undo();
    if (cmd == null) return null;
    if (cmd.id == "trend_line") {
      trendPoints.removeRange(trendPoints.length - 2, trendPoints.length);
      return Offset.zero; // returns for UI refresh if needed
    }
    return null;
  }

  Offset? redoTrendLine() {
    final cmd = manager.redo();
    if (cmd == null) return null;
    if (cmd.id == "trend_line") {
      final a = cmd.data['a'] as Offset;
      final b = cmd.data['b'] as Offset;
      trendPoints.addAll([a, b]);
      return b;
    }
    return null;
  }

  void clearAll() {
    manager.clear();
    trendPoints.clear();
  }
}
