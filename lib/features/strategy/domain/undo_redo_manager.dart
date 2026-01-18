class UndoRedoManager<T> {
  final List<T> _stack = [];
  int _pointer = -1;

  void add(T state) {
    _stack.removeRange(_pointer + 1, _stack.length);
    _stack.add(state);
    _pointer++;
  }

  T? undo() => _pointer > 0 ? _stack[--_pointer] : null;
  T? redo() => _pointer < _stack.length - 1 ? _stack[++_pointer] : null;
}
