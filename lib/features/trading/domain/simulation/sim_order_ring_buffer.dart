class SimOrderRingBuffer<T> {
  final int capacity;
  final List<T> _vals = [];
  int _idx = 0;

  SimOrderRingBuffer(this.capacity);

  void add(T val) {
    if (_vals.length < capacity) {
      _vals.add(val);
    } else {
      _vals[_idx] = val;
      _idx = (_idx + 1) % capacity;
    }
  }

  List<T> list() => List.unmodifiable(_vals);
}
