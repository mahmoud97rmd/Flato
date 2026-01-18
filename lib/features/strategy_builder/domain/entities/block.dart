import 'block_type.dart';

class Block {
  final String id; // unique
  final BlockType type;
  final Map<String, dynamic> params; // e.g., period, threshold
  Block({required this.id, required this.type, Map<String, dynamic>? params})
      : this.params = params ?? {};
}
