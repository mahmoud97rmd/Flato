class RingBuffer<T> {
  final int capacity;
  final List<T> _buffer = [];
  int _index = 0;

  RingBuffer(this.capacity);

  void add(T item) {
    if (_buffer.length < capacity) {
      _buffer.add(item);
    } else {
      _buffer[_index] = item;
      _index = (_index + 1) % capacity;
    }
  }

  List<T> toList() => List.unmodifiable(_buffer);
}
