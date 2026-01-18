import '../../../../core/network/oanda/client/oanda_rest_client.dart';
import '../../../../core/network/oanda/stream/oanda_ws_client.dart';

class OandaMarketRepository {
  final OandaRestClient _rest = OandaRestClient();
  final OandaWSClient _ws = OandaWSClient();

  Future<List<String>> getInstruments() => _rest.fetchInstruments();

  Future<List<Map<String, dynamic>>> getCandles(
          String symbol, String timeframe) =>
      _rest.fetchCandles(symbol, timeframe);

  void subscribePricing(String symbol, void Function(dynamic) onData) {
    _ws.connect(symbol, onData);
  }

  void unsubscribe() {
    _ws.disconnect();
  }
}
