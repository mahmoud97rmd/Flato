import 'dart:async';
mixin AlertBlocCleanup {
  final List<StreamController> _controllers = [];

  void addController(StreamController c) => _controllers.add(c);

  @override
  Future<void> close() async {
    for (final c in _controllers) {
      await c.close();
    }
    await super.close();
  }
}
