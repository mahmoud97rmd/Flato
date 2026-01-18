import 'package:hive/hive.dart';

class WatchlistManager {
  final Box _box = Hive.box("watchlist_box");

  List<String> getAll() =>
      _box.values.cast<String>().toList();

  Future<void> add(String symbol) async {
    if (!_box.values.contains(symbol)) {
      await _box.add(symbol);
    }
  }

  Future<void> remove(String symbol) async {
    final key = _box.keys
        .firstWhere((k) => _box.get(k) == symbol);
    await _box.delete(key);
  }
}
