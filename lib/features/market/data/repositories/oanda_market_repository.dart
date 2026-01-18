import '../../../../core/network/http/rest_client.dart';
import '../../domain/entities/candle.dart';
import '../../domain/entities/instrument.dart';
import '../../domain/repositories/market_repository.dart';
import '../dtos/candle_dto.dart';
import '../dtos/instrument_dto.dart';
import '../mappers/candle_mapper.dart';
import '../mappers/instrument_mapper.dart';

class OandaMarketRepository implements MarketRepository {
  final RestClient _client;

  OandaMarketRepository(this._client);

  @override
  Future<List<Candle>> fetchHistoricalCandles(
      String accountId, String instrument, String timeframe) async {
    final path =
        "/accounts/\$accountId/instruments/\$instrument/candles?granularity=\$timeframe&count=500";
    final res = await _client.get(path);

    final List list = res["candles"] as List;
    return list
        .map((e) => CandleMapper.fromDto(
            CandleDTO.fromJson(e as Map<String, dynamic>)))
        .toList();
  }

  @override
  Future<List<Instrument>> fetchInstruments(String accountId) async {
    final path = "/accounts/\$accountId/instruments";
    final res = await _client.get(path);

    final List list = res["instruments"] as List;
    return list
        .map((e) => InstrumentMapper.fromDto(
            InstrumentDTO.fromJson(e as Map<String, dynamic>)))
        .toList();
  }
}
