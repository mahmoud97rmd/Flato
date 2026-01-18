import 'package:hive/hive.dart';
import 'replay_hive.dart';

class ReplayStorage {
  static const _box = "replay_box";

  Future<void> save(String symbol, int index) async {
    final box = await Hive.openBox<ReplayStateEntity>(_box);
    await box.put(symbol, ReplayStateEntity(symbol: symbol, lastIndex: index));
  }

  Future<ReplayStateEntity?> load(String symbol) async {
    final box = await Hive.openBox<ReplayStateEntity>(_box);
    return box.get(symbol);
  }
}
