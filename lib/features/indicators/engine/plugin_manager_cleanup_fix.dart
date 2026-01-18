import 'indicator_engine.dart';

class PluginManagerCleanupFix {
  final List<IndicatorPlugin> _active = [];

  void add(IndicatorPlugin p) {
    _active.add(p);
  }

  void remove(IndicatorPlugin p) {
    _active.removeWhere((x) => x == p);
    // تحرّر أي مورد داخلي داخل p إن وجد
  }

  void clear() => _active.clear();
}
