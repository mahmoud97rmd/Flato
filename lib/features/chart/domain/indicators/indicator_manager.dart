import 'indicator_base.dart';
import 'ema_indicator.dart';
import 'rsi_indicator.dart';
import 'macd_indicator.dart';

class IndicatorManager {
  final List<Indicator> _active = [];

  void add(Indicator i) {
    if (!_active.any((e) => e.name == i.name)) _active.add(i);
  }

  void remove(String name) {
    _active.removeWhere((e) => e.name == name);
  }

  List<Indicator> get all => List.unmodifiable(_active);

  void clear() => _active.clear();
}
