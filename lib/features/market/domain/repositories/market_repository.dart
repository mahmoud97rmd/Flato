import '../entities/candle.dart';
import '../entities/instrument.dart';

abstract class MarketRepository {
  Future<List<Candle>> fetchHistoricalCandles(
    String accountId,
    String instrument,
    String timeframe,
  );

  Future<List<Instrument>> fetchInstruments(String accountId);
}
