mixin SideEffectQueue<E> on BlocBase<E> {
  final List<E> _effects = [];

  void addEffect(E effect) => _effects.add(effect);

  List<E> consumeEffects() {
    final copy = List<E>.from(_effects);
    _effects.clear();
    return copy;
  }
}
