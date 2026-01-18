import 'market_definitions.dart';

class MarketSearchFilter {
  static List<Instrument> search(List<Instrument> all, String q) {
    return all.where((i) => i.symbol.contains(q.toUpperCase())).toList();
  }

  static List<Instrument> sortByName(List<Instrument> all) {
    all.sort((a, b) => a.symbol.compareTo(b.symbol));
    return all;
  }
}
