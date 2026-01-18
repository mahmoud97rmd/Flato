import 'market_definitions.dart';

class MarketFilter {
  static List<Instrument> byType(List<Instrument> list, MarketType type) =>
      list.where((i) => i.type == type).toList();
}
