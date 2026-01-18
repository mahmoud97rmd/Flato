import 'indicator_engine.dart';

class PluginManagerFix {
  final List<IndicatorPlugin> _plugins = [];

  void add(IndicatorPlugin p) => _plugins.add(p);

  void remove(IndicatorPlugin p) => _plugins.remove(p);

  void clear() => _plugins.clear();

  List<IndicatorPlugin> get active => List.unmodifiable(_plugins);
}
