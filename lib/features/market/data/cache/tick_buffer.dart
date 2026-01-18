import '../../../core/models/tick_entity.dart';

class TickBuffer {
  final List<TickEntity> buffer = [];

  void add(TickEntity t) => buffer.add(t);

  List<TickEntity> flush() {
    final copy = List<TickEntity>.from(buffer);
    buffer.clear();
    return copy;
  }
}
