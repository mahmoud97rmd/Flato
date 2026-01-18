typedef InitFuture = Future<void> Function();

class BlocInitCoordinator {
  final List<InitFuture> _initializers = [];

  void add(InitFuture fn) => _initializers.add(fn);

  Future<void> run() async {
    for (final init in _initializers) {
      await init();
    }
  }
}
